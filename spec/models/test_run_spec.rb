require 'spec_helper'

describe TestRun do
  subject { build(:test_run) }

  describe 'validations' do
    it 'requires a user' do
      subject.user_id = nil
      expect(subject).not_to be_valid
    end

    it 'requires a test' do
      subject.test_id = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
      it 'should run at now' do
        subject.save

        expect(subject.run_at).to be_within(1.second).of(Time.now)
      end

      it 'should send the job to process the run' do
        expect(TestRunWorker).to receive(:perform_async).with(subject.id)

        subject.save
      end
    end
  end
end
