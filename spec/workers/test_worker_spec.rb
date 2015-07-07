require 'spec_helper'

describe TestWorker do
  let(:user) { create(:user) }
  let(:test) { create(:test, :user => user) }

  let(:perform) { subject.perform(test) }

  it { expect(described_class.sidekiq_options['queue']).to eq(:exigent) }

  describe '#perform' do
    it 'should set the next run time' do
      test.update(:at => 4.minutes.from_now)
      perform

      test.reload
      expect(test.at).to be_within(1.second).of((6.hours+4.minutes).from_now)
    end

    it 'should create a test run' do
      expect {
        perform
      }.to change(TestRun, :count).by(1)
    end

    it 'should have the attributes' do
      perform

      test_run = TestRun.last
      expect(test_run.user).to eq(user)
      expect(test_run.test).to eq(test)
    end
  end
end
