class TestRuns < Application
  before_action :load_test, :only => [:create]

  def create
    user.test_runs.create(:test => @model)

    respond
  end

  private

  def load_test
    @model = user.tests.find(params[:test_id])
  end

end
