require 'spec_helper'

describe CheckStatus do
  let(:status) { 302 }
  let(:check) { create(:check, :kind => Kind::Check::STATUS, :value => '302') }
  let(:response) { Response.from_api.tap {|r| r.code = status } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckStatus }

  describe '#to_s' do
    its(:to_s) { should == 'Status equals 302' }
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

    describe 'when the status is different' do
      let(:status) { [502,200,301].sample }

      it 'should not be successful' do
        call

        expect(subject.success?).to eq(false)
      end
    end
  end
end
