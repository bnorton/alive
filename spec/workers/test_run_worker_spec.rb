require 'spec_helper'

describe TestRunWorker do
  let(:test) { create(:test) }
  let(:test_run) { create(:test_run, :test => test) }
  let!(:response) { Response.new(Typhoeus::Response.new) }

  let(:perform) { subject.perform(test_run) }

  describe '#perform' do
    before do
      allow(Request).to receive(:run).and_return(response)
    end

    it 'should make the request' do
      expect(Request).to receive(:run).with(test).and_return(response)

      perform
    end

    it 'should have the request starting time' do
      perform

      test_run.reload
      expect(test_run.at).to be_within(1.second).of(Time.now)
    end

    it 'should have the request duration' do
      allow(Request).to receive(:run).with(test) do
        Timecop.travel(31.seconds)

        response.duration = 31
        response
      end

      perform

      test_run.reload
      expect(test_run.at).to be_within(1.second).of(31.seconds.ago)
      expect(test_run.duration).to eq(31)
      expect(test_run.duration).to be >= 31.seconds
      expect(test_run.duration).to be <= (32.seconds)
    end

    describe 'when there are checks' do
      let!(:checks) { [
        create(:check, :test => test, :kind => Kind::Check::STATUS),
        create(:check, :test => test, :kind => Kind::Check::HEADER),
        create(:check, :test => test, :kind => Kind::Check::BODY),
        create(:check, :test => test, :kind => Kind::Check::TIME),
      ] }

      before do
        decorator = double(:decorator, :call => true)

        allow(CheckStatus).to receive(:new).and_return(decorator)
        allow(CheckHeader).to receive(:new).and_return(decorator)
        allow(CheckBody).to receive(:new).and_return(decorator)
        allow(CheckTime).to receive(:new).and_return(decorator)
      end

      it 'should run the status check' do
        expect(CheckStatus).to receive(:new).with(checks.first).and_return(decorator = double(:decorator))
        expect(decorator).to receive(:call).with(response).and_return(true)

        perform
      end

      it 'should run the header check' do
        expect(CheckHeader).to receive(:new).with(checks.second).and_return(decorator = double(:decorator))
        expect(decorator).to receive(:call).with(response).and_return(true)

        perform
      end

      it 'should run the body check' do
        expect(CheckBody).to receive(:new).with(checks.third).and_return(decorator = double(:decorator))
        expect(decorator).to receive(:call).with(response).and_return(true)

        perform
      end

      it 'should run the time check' do
        expect(CheckTime).to receive(:new).with(checks.fourth).and_return(decorator = double(:decorator))
        expect(decorator).to receive(:call).with(response).and_return(true)

        perform
      end

      describe 'when one of the checks fail' do
        before do

          klass, @check = *[[CheckHeader, checks.second], [CheckBody, checks.third]].sample

          allow(klass).to receive(:new).and_return(decorator = double(:decorator, :call => false))
          allow(CheckStatus).to receive(:new).and_return(decorator = double(:decorator, :call => true))
        end

        it 'should fail the test run' do
          perform

          test_run.reload
          expect(test_run.failed_check_id).to eq(@check.id)
        end

        it 'should not run the subsequent checks' do
          expect(CheckTime).not_to receive(:new)

          perform
        end
      end
    end
  end
end
