require 'spec_helper'

describe User do
  subject { build(:user) }

  describe 'validations' do
    it 'requires an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'requires a password' do
      subject.password = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
      it 'should have a token' do
        subject.save

        expect(subject.token).to match(/^[0-9a-zA-Z]{4,24}$/)
      end
    end
  end

  describe '#password, #password=, #password_is?' do
    it 'should salt the password' do
      subject.password = 'my-password'

      expect(subject.password).to eq(Digest::SHA256.hexdigest('my-password|'+subject.salt))
      expect(subject.password_is?('my-password')).to eq(true)
    end

    describe 'for a missing password' do
      it 'should not be good to go' do
        value = [' ', nil, '', "\n"].sample

        subject.password = value
        expect(subject.password).to eq(nil)
        expect(subject.password_is?(value)).to eq(false)
        expect(subject.valid?).to eq(false)
      end
    end
  end
end
