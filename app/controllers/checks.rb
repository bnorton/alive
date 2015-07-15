class Checks < Application
  before_action :load_test, :only => [:new, :create]
  before_action :load_model, :only => [:edit, :update]

  html :new, :edit

  def create
    @check = @model.checks.new

    update
  end

  def update
    @check.update(params.permit(*Check.allows))

    respond @check
  end

  private

  def load_test
    @model = user.tests.find(params[:test_id])
  end

  def load_model
    @check = Check.find(params[:id])
    @model = user.tests.find(@check.test_id) # security
  end

end
