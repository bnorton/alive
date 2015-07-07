class TestWorker < Worker
  worker :queue => :exigent

  def perform(test_id)
    test = Test.find(test_id)

    test.update(:at => [Time.now,test.at].min+test.interval)

    TestRun.create(:user_id => test.user_id, :test => test)
  end
end
