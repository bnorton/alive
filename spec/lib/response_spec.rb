require 'spec_helper'

describe Response do
  let(:code) { 200 }
  let(:body) { '{"id":5,"name":"John Doe"}' }
  let(:headers) { "Content-Type: application/json\nContent-Length: 3\n" }
  let(:raw_response) { Typhoeus::Response.new(:code => code, :body => body, :headers => headers, :total_time => 245) }

  subject { described_class.new(raw_response) }

  describe '#raw' do
    its(:raw) { should == raw_response }
  end

  describe '#code' do
    its(:code) { should == 200 }

    describe 'when the response is an error' do
      let(:code) { 429 }

      its(:code) { should == 429 }
    end

    describe 'when the response was an error' do

    end
  end

  describe '#body' do
    its(:body) { should == { 'id' => 5, 'name' => 'John Doe' } }

    describe 'when the body is HTML' do
      let(:body) { '<div class="foo-bar"></div>' }

      its(:body) { should == '<div class="foo-bar"></div>' }
    end

    describe 'when the body is text' do
      let(:body) { 'status:202' }

      its(:body) { should == 'status:202' }
    end
  end

  describe '#headers' do
    its(:headers) { should == { 'Content-Type' => 'application/json', 'Content-Length' => '3' } }

    it 'fetches headers' do
      expect(subject.headers['Content-Type']).to eq('application/json')
      expect(subject.headers['Content-Length']).to eq('3')
    end

    it 'fetches down-cased headers' do
      expect(subject.headers['content-type']).to eq('application/json')
      expect(subject.headers['content-length']).to eq('3')
    end
  end

  describe '#duration' do
    its(:duration) { should == 245 }
  end
end
