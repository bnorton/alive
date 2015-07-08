require 'spec_helper'

describe CheckAction do
  let(:check) { create(:check, :kind => Kind::Check::ACTION, :value => 'something-special') }
  let(:session) { instance_double(Capybara::Session) }
  let(:response) { Response.from_browser(session) }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckAction }

  describe '#to_s' do
    its(:to_s) { should == 'Click on something-special' }
  end

  describe '#call' do
    let(:call) { subject.call(response) }

    before do
      allow(session).to receive(:response_headers).and_return({})
      allow(session).to receive(:click_link_or_button)

      response
    end

    it 'should fill the input' do
      expect(session).to receive(:click_link_or_button).with('something-special')

      call
    end

    it 'should be successful' do
      call

      expect(subject.success?).to eq(true)
    end

    it 'should have the response' do
      call

      expect(subject.response).to be(response)
    end

    describe 'when the item is not found' do
      before do
        allow(session).to receive(:click_link_or_button).and_raise(Capybara::ElementNotFound)
      end

      it 'should not be successful' do
        call

        expect(subject.success?).to eq(false)
      end
    end
  end
end
