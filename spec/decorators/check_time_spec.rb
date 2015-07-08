require 'spec_helper'

describe CheckTime do
  let(:time) { 430.0 }
  let(:check) { create(:check, :kind => Kind::Check::TIME, :value => '440') }
  let(:response) { Response.from_api.tap {|r| r.duration = time } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckTime }

  describe '#to_s' do
    its(:to_s) { should == 'Response time is less than 440ms' }
  end

  describe '#call' do
    let(:call) { subject.call(response) }

    it 'should be successful' do
      call

      expect(subject.success?).to eq(true)
    end

    it 'should have the response' do
      call

      expect(subject.response).to be(response)
    end

    describe 'when the duration exceeds the max' do
      let(:time) { 450.0 }

      it 'should not be successful' do
        call

        expect(subject.success?).to eq(false)
      end
    end
  end
end
