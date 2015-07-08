require 'spec_helper'

describe CheckVisit do
  let(:check) { create(:check, :kind => Kind::Check::VISIT, :value => 'http://google.com/') }
  let(:session) { instance_double(Capybara::Session) }
  let(:response) { Response.from_browser(session) }
  let(:new_response) { Response.from_browser }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckVisit }

  describe '#to_s' do
    its(:to_s) { should == 'Navigate to http://google.com/' }
  end

  describe '#call' do
    let(:call) { subject.call(response) }

    before do
      allow(session).to receive(:response_headers).and_return({})
      allow(session).to receive(:status_code).and_return(200)
      allow(session).to receive(:visit)

      response
      allow(Response).to receive(:from_browser).with(session).once.and_return(new_response)
    end

    it 'should visit the page' do
      expect(session).to receive(:visit).with('http://google.com/')

      call
    end

    it 'should be successful' do
      call

      expect(subject.success?).to eq(true)
    end

    it 'should have the new response' do
      call

      expect(subject.response).to be(new_response)
    end

    describe 'when visit is not a successful status 200' do
      before do
        allow(session).to receive(:status_code).and_return([201, 301, 404, 502].sample)
      end

      it 'should not be successful' do
        call

        expect(subject.success?).to eq(false)
      end
    end
  end
end
