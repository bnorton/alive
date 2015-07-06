require 'spec_helper'

describe SlackOn do
  let(:user) { create(:user, :notify_slack => true) }
  let!(:notifier) { double(:notifier, :ping => nil) }

  let(:test) { create(:test, :user => user, :name => 'Ping Google', :url => 'google.com') }
  let(:test_run) { create(:test_run, :test => test, :code => 434, :duration => 809.0) }

  before do
    allow(Slack::Notifier).to receive(:new).and_return(notifier)
  end

  describe '.ping' do
    it 'should create a notifier' do
      expect(Slack::Notifier).to receive(:new).with('http://slack-webhook-url.com', :channel => '#slack_channel').and_return(notifier)

      described_class.ping ''
    end

    it 'should send the message to the notifier' do
      expect(notifier).to receive(:ping).with('Message')

      described_class.ping 'Message'
    end

    it 'should send the options to the notifier' do
      expect(notifier).to receive(:ping).with("Message\n - Key A: value1\n - Keyb: value2")

      described_class.ping 'Message', :key_a => 'value1', :keyb => 'value2'
    end

    describe 'when slack is not configured' do
      before do
        @url = ENV['SLACK_URL']
        ENV['SLACK_URL'] = ''
      end

      after { ENV['SLACK_URL'] = @url }

      it 'should not notify' do
        expect(Slack::Notifier).not_to receive(:new)

        described_class.ping ''
      end
    end
  end

  describe '.passed' do
    let(:passed) { described_class.passed(user, test_run) }

    it 'should send the message' do
      expect(described_class).to receive(:ping).with('Ping Google - Passed', anything)

      passed
    end

    it 'should send the test run information' do
      expect(described_class).to receive(:ping).with(anything, hash_including(:what => 'GET google.com', :response_code => '`434`', :response_duration => '`809ms`'))

      passed
    end
  end

  describe '.failed' do
    let(:check) { create(:check, :test => test) }
    let(:failed) { described_class.failed(user, test_run) }

    before do
      test_run.failed_check = check
    end

    it 'should send the message' do
      expect(described_class).to receive(:ping).with('Ping Google - Failed', anything)

      failed
    end

    it 'should send the test run information' do
      expect(described_class).to receive(:ping).with(anything, hash_including(:what => 'GET google.com', :which => check.decorator.new(check).to_s, :response_code => '`434`', :response_duration => '`809ms`'))

      failed
    end
  end
end
