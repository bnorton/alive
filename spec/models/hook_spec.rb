require 'spec_helper'

describe Hook do
  subject { build(:hook) }

  describe 'validations' do
    it 'requires a test' do
      subject.test_id = nil
      expect(subject).not_to be_valid
    end

    it 'requires a url' do
      subject.url = nil
      expect(subject).not_to be_valid
    end

    it 'requires a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
      it 'should not include full response data by default' do
        subject.save
        expect(subject.include_response).to eq(false)
      end
      it 'should be disabled by default' do
        subject.save
        expect(subject.enabled).to eq(false)
      end
    end
  end

end
