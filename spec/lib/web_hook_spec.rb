require 'spec_helper'

describe WebHook do
  let(:hook_url) {'http://foo.bar/hook'}
  let(:breed) { 'post' }
  let(:headers) { '{"Accept":"gzip,deflate","Authorization":"Bearer FGH345","Content-Type":"application/json"}' }
  let(:test) { create(:test, :breed => breed, :url => 'http://foo.bar/foo', :headers => headers, :json => true, :body => '{"abc":123,"123":"abc"}') }
  let(:check) { create(:check, :test => test) }
  let(:hook) { create(:hook, :test => test, :url => hook_url, :enabled => true, :include_response => true) }
  let(:test_run) { create(:test_run, :code => 200, :duration => 123.12, :test => test, :failed_check => check, :headers=>"test header", :body=>"test body") }

  let!(:request) { double(Typhoeus::Request, :run => response) }
  let!(:response) { Typhoeus::Response.new }

  let(:run) { described_class.run(hook, test_run) }

  describe '.run' do

    before do
      allow(Typhoeus::Request).to receive(:new).and_return(request)
    end

    it 'should make the request' do
      expect(request).to receive(:run)

      run
    end

    it 'should request the url' do
      expect(Typhoeus::Request).to receive(:new).with(hook_url, anything).and_return(request)

      run
    end

    it 'should send the request body with correct details' do
      expect(Typhoeus::Request).to receive(:new){ |url,data|
        expect(data).to include(:body)
        body = Oj.load(data[:body])
        expect(body).to include('id','code','run_at','success','duration','failed_check_id','test','headers','body')
        expect(body['success']).to eq(false)
      }.and_return(request)

      run
    end

    describe 'when include_response is false' do

      before do
        hook.include_response=false
      end

      it 'should not send the response data' do
        expect(Typhoeus::Request).to receive(:new){ |url,data|
          expect(Oj.load(data[:body])).not_to include('headers','body')
        }.and_return(request)

        run
      end
    end

    describe 'when there is no failed_check_id' do

      before do
        test_run.failed_check_id = nil
      end

      it 'should set success to true' do
        expect(Typhoeus::Request).to receive(:new){ |url,data|
          expect(Oj.load(data[:body])['success']).to eq(true)
        }.and_return(request)

        run
      end
    end

    it 'should return the response' do
      expect(run.class).to eq(Response)
      expect(run.raw).to eq(response)
    end

  end
end
