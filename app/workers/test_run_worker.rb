class TestRunWorker < Worker
  def perform(test_run_id)
    test_run = TestRun.find(test_run_id)
    test_run.at = Time.now

    response = Request.run(test_run.test)

    failed_check = test_run.test.checks.each.find do |check|
      !check.decorator.new(check).call(response)
    end

    test_run.test.update(:last_code => response.code, :last_duration => response.duration, :last_success => !failed_check.try(:id))
    test_run.update( :failed_check_id => failed_check.try(:id), **response.to_hash)
  end
end
