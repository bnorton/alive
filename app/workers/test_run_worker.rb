class TestRunWorker < Worker
  def perform(test_run_id)
    test_run = TestRun.find(test_run_id)
    test_run.at = Time.now

    response = Request.run(test_run.test)

    failed_check = Check.where(:test_id => test_run.test_id).each.find do |check|
      !check.decorator.new(check).call(response)
    end

    test_run.failed_check_id = failed_check.try(:id)
    test_run.duration = response.duration
    test_run.save
  end
end
