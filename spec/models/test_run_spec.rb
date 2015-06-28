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
    end
  end
end
