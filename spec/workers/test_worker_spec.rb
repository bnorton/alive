require 'spec_helper'

describe TestWorker do
  let(:user) { create(:user) }
  let(:test) { create(:test, :user => user) }

  let(:perform) { subject.perform(test) }

  describe '#perform' do
    it 'should create a test run' do
      expect {
        perform
      }.to change(TestRun, :count).by(1)
    end

    it 'should have the attributes' do
      perform

      run = TestRun.last
      expect(run.user).to eq(user)
      expect(run.test).to eq(test)
    end

    it 'should set the next run time' do
      perform

      test.reload
      expect(test.at).to be_within(1.second).of(6.hours.from_now)
    end

    it 'should send the job to process the run' do
      expect(TestRunWorker).to receive(:perform_async) do |id|
        @run_id = id
      end

      perform

      expect(@run_id).to eq(TestRun.last.id)
    end
  end
end
