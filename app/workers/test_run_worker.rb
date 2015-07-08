class TestRunWorker < Worker
  def perform(test_run_id)
    test = (test_run = TestRun.find(test_run_id)).test
    last_failed = !test.last_success
    test_run.at = Time.now

    response = Request.run(test)

    failed_check = test.checks.each.find do |check|
      decorator = check.decorator.new(check)
      decorator.call(response)
      response = decorator.response

      !decorator.success?
    end

    test.update(:last_code => response.code, :last_duration => response.duration, :last_success => !failed_check.try(:id), :last_at => Time.now)
    test_run.update( :failed_check_id => failed_check.try(:id), **response.to_hash)

    if failed_check
      Notify.completed(:failed, test_run)
    elsif last_failed
      Notify.completed(:passed, test_run)
    end
  end
end
