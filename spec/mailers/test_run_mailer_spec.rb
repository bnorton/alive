require 'spec_helper'

describe TestRunMailer do
  let(:user) { create(:user) }
  let(:test) { create(:test, :name => 'Ping Google', :breed => 'head', :url => 'google.com') }
  let(:check) { create(:check, :kind => Kind::Check::HEADER, :key => 'Location', :value => 'google.com') }
  let(:test_run) { create(:test_run, :test => test, :failed_check => check, :code => 401, :duration => 308.0) }

  describe '.passed' do
    it 'should send the email' do
      email = nil
      expect {
        email = described_class.deliver(:passed, user, test_run)
      }.to change(ActionMailer::Base.deliveries, :count).by(1)

      expect(email.to).to eq([user.email])
      expect(email.subject).to eq('[Alive] Ping Google - Passed')
      expect(email.body).to match(/Passed Test: Ping Google/)
      expect(email.body).to match(/HEAD google\.com returned status 401 in 308ms/)
    end

    describe 'testing Mailer - when sendgrid is not enabled' do
      before do
        @username = ENV['SENDGRID_USERNAME']
        ENV['SENDGRID_USERNAME'] = ''
      end

      after do
        ENV['SENDGRID_USERNAME'] = @username
      end

      it 'should not send the email' do
        email = nil
        expect {
          email = described_class.deliver(:passed, user, test_run)
        }.not_to change(ActionMailer::Base.deliveries, :count)

        expect(email).to eq(nil)
      end
    end
  end

  describe '.failed' do
    it 'should send the email' do
      email = nil
      expect {
        email = described_class.deliver(:failed, user, test_run)
      }.to change(ActionMailer::Base.deliveries, :count).by(1)

      expect(email.to).to eq([user.email])
      expect(email.subject).to eq('[Alive] Ping Google - Failed')
      expect(email.body).to match(/Failed Test: Ping Google/)
      expect(email.body).to match(/HEAD google\.com returned status 401 in 308ms/)
      expect(email.body).to match(/Failed Check: #{check.decorator.new(check)}/)
    end
  end
end
