class Notify
  def self.completed(type, test_run)
    user = test_run.test.user

    SlackOn.send(type, user, test_run) if user.notify_slack
    TestRunMailer.deliver(type, user, test_run) if user.notify_email
  end
end
