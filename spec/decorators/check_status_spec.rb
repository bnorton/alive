require 'spec_helper'

describe CheckStatus do
  let(:status) { 302 }
  let(:check) { create(:check, :kind => Kind::Check::STATUS, :value => '302') }
  let(:response) { Response.new.tap {|r| r.code = status } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckStatus }

  describe '#call' do
    let(:call) { subject.call(response) }

    it 'should be true' do
      expect(call).to eq(true)
    end

    describe 'when the status is different' do
      let(:status) { [502,200,301].sample }

      it 'should be false' do
        expect(call).to eq(false)
      end
    end
  end
end
