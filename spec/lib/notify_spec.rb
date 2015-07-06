require 'spec_helper'

describe Notify do
  let(:user) { create(:user) }
  let(:test) { create(:test, :user => user) }
  let(:check) { create(:check, :test => test) }
  let(:test_run) { create(:test_run, :test => test, :failed_check => check) }

  before do
    allow(SlackOn).to receive(:passed)
  end

  describe '.completed' do
    let(:pass_fail) { %i(passed failed).sample }
    let(:passed) { described_class.completed(pass_fail, test_run) }

    it 'should e-mail the user' do
      expect(TestRunMailer).to receive(:deliver).with(pass_fail, user, test_run)

      passed
    end

    it 'should not X the user' do
      expect(SlackOn).not_to receive(pass_fail)

      passed
    end

    describe 'when not notifying by e-mail' do
      before do
        user.notify_email = false
      end

      it 'should not e-mail the user' do
        expect(TestRunMailer).not_to receive(:deliver)

        passed
      end
    end

    describe 'when notifying by slack' do
      before do
        user.notify_slack = true
      end

      it 'should slack the user' do
        expect(SlackOn).to receive(pass_fail).with(user, test_run)

        passed
      end
    end
  end
end
