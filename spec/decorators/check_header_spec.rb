require 'spec_helper'

describe CheckHeader do
  let(:key) { 'Content-Type' }
  let(:type) { 'application/json' }
  let(:check) { create(:check, :kind => Kind::Check::HEADER, :key => key, :value => 'application/json') }
  let(:response) { Response.from_api.tap {|r| r.headers = { key => type } } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckHeader }

  describe '#to_s' do
    its(:to_s) { should == "Header #{key} equals application/json" }
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

    describe 'when the value is different' do
      let(:type) { 'application/xml' }

      it 'should not be successful' do
        call

        expect(subject.success?).to eq(false)
      end
    end
  end
end
