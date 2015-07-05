class Checks < Application
  before_action :load_test, :only => [:new, :create]
  before_action :load_model, :only => [:edit, :update]

  def new
  end

  def create
    @check = @test.checks.new

    update
  end

  def edit
  end

  def update
    @check.update(params.permit(*Check.allows))

    redirect_to @test
  end

  private

  def load_test
    @test = user.tests.find(params[:test_id])
  end

  def load_model
    @check = Check.find(params[:id])
    @test = user.tests.find(@check.test_id) # security
  end

end
