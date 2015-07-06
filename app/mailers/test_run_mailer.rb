class TestRunMailer < Mailer
  def passed(user, test_run)
    common(user, test_run, :Passed)
  end

  def failed(user, test_run)
    common(user, test_run, :Failed)
  end

  private

  def common(user, test_run, name)
    @user, @test, @run = user, test_run.test, test_run

    mail(:to => user.email, :subject => "[Alive] #{@test.name} - #{name}")
  end
end
