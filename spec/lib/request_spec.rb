require 'spec_helper'

describe Request do
  let(:breed) { 'get' }
  let(:headers) { '{"Accept":"gzip,deflate","Authorization":"Bearer FGH345"}' }
  let(:body) { '{"abc":123,"123":"abc"}' }
  let(:test) { create(:test, :breed => breed, :url => 'http://foo.bar/foo', :headers => headers, :json => true, :body => body) }

  let!(:request) { double(Typhoeus::Request, :run => response) }
  let!(:response) { Typhoeus::Response.new }

  let(:run) { described_class.run(test) }

  describe '.run' do
    let(:breed) { %w(get head delete).sample }

    before do
      allow(Typhoeus::Request).to receive(:new).and_return(request)
    end

    it 'should make the request' do
      expect(request).to receive(:run)

      run
    end

    it 'should request the url' do
      expect(Typhoeus::Request).to receive(:new).with('http://foo.bar/foo', anything).and_return(request)

      run
    end

    it 'should request the breed' do
      expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(method: breed.to_sym)).and_return(request)

      run
    end

    it 'should send the request headers' do
      expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(headers: JSON.parse(headers))).and_return(request)

      run
    end

    it 'should send the request params' do
      expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(params: JSON.parse(body))).and_return(request)

      run
    end

    it 'should return the response' do
      expect(run.class).to eq(Response)
      expect(run.raw).to eq(response)
    end

    describe 'with a body' do
      let(:breed) { %w(post put patch).sample }

      it 'should send the request headers' do
        expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(headers: JSON.parse(headers).merge('Content-Type' => 'application/json'))).and_return(request)

        run
      end

      it 'should send the request body' do
        expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(body: JSON.parse(body))).and_return(request)

        run
      end

      describe 'when the request is not a json request' do
        before do
          test.json = false
        end

        it 'should send the request headers' do
          expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(headers: JSON.parse(headers).merge('Content-Type' => 'application/x-www-form-urlencoded'))).and_return(request)

          run
        end
      end

      describe 'when the request has no headers' do
        before do
          test.headers = [nil, '', "\n "].sample
        end

        it 'should send the default headers' do
          expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(:headers => {'Content-Type' => 'application/json'})).and_return(request)

          run
        end
      end

      describe 'when the request has no body' do
        before do
          test.body = [nil, '', "\n "].sample
        end

        it 'should send the default body' do
          expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(:body => {})).and_return(request)

          run
        end
      end
    end
  end
end
