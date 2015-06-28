require 'spec_helper'

describe Check do
  subject { build(:check) }

  describe 'validations' do
    it 'requires a test' do
      subject.test_id = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
    end
  end

  describe '#decorator' do
    Kind::Check::VALUES.each do |kind|
      it "should have the #{kind} decorator" do
        subject.kind = kind

        expect(subject.decorator).to eq("Check#{kind.titleize}".constantize)
      end
    end
  end
end
