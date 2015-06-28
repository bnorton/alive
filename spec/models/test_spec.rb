require 'spec_helper'

describe Test do
  subject { build(:test) }

  describe 'validations' do
    it 'requires a user' do
      subject.user_id = nil
      expect(subject).not_to be_valid
    end

    it 'requires a url' do
      subject.url = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
      it 'should process the new test' do
        expect(TestWorker).to receive(:perform_async).with(subject.id)

        subject.save
      end

      it 'should have the run interval' do
        subject.save

        expect(subject.interval).to be(6.hours.to_i)
      end
    end
  end
end
