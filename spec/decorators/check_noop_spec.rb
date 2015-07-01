require 'spec_helper'

describe CheckNoop do
  let(:check) { create(:check) }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckNoop }

  describe '#to_s' do
    its(:to_s) { should == 'Check nothing - noop' }
  end

  describe '#call' do
    let(:call) { subject.call('anything', {:foo => 'bar'}) }

    it 'should be true' do
      expect(call).to eq(true)
    end
  end
end
