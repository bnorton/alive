require 'spec_helper'

describe CheckTime do
  let(:time) { 430 }
  let(:check) { create(:check, :kind => Kind::Check::TIME, :value => '440') }
  let(:response) { Response.new.tap {|r| r.duration = time } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckTime }

  describe '#call' do
    let(:call) { subject.call(response) }

    it 'should be true' do
      expect(call).to eq(true)
    end

    describe 'when the duration exceeds the max' do
      let(:time) { 450 }

      it 'should be false' do
        expect(call).to eq(false)
      end
    end
  end
end
