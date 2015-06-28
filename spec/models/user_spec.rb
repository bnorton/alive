require 'spec_helper'

describe User do
  subject { build(:user) }

  describe 'validations' do
    it 'requires an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
    end
  end
end
