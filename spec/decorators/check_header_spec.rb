require 'spec_helper'

describe CheckHeader do
  let(:key) { 'Content-Type' }
  let(:type) { 'application/json' }
  let(:check) { create(:check, :kind => Kind::Check::HEADER, :key => key, :value => 'application/json') }
  let(:response) { Response.new.tap {|r| r.headers = { key => type } } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckHeader }

  describe '#call' do
    let(:call) { subject.call(response) }

    it 'should be true' do
      expect(call).to eq(true)
    end

    describe 'when the value is different' do
      let(:type) { 'application/xml' }

      it 'should be false' do
        expect(call).to eq(false)
      end
    end
  end
end
