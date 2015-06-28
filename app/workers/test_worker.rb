class TestWorker < Worker
  def perform(test_id)
    test = Test.find(test_id)

    test.update(:at => Time.now+test.interval)

    run = TestRun.create(:user => test.user, :test => test)
    TestRunWorker.perform_async(run.id)
  end
end
