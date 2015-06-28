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
      it 'should have the next test index' do
        subject.user = user = create(:user).tap {|u| u.update(:test_index => 13) }
        subject.save

        expect(subject.index).to eq(14)
        expect(user.test_index).to eq(14)
      end

      it 'should have the run time' do
        subject.save

        expect(subject.at).to be_within(1.second).of(Time.now)
      end

      it 'should have the run interval' do
        subject.save

        expect(subject.interval).to be(6.hours.to_i)
      end
    end
  end
end
