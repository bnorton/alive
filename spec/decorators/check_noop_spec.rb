require 'spec_helper'

describe CheckNoop do
  let(:check) { create(:check) }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckNoop }

  describe '#call' do
    let(:call) { subject.call('anything', {:foo => 'bar'}) }

    it 'should be true' do
      expect(call).to eq(true)
    end
  end
end
