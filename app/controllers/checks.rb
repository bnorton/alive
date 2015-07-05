class Checks < Application
  before_action :load_model

  def edit
  end

  def update
    @check.update(params.permit(*Check.allows))

    redirect_to @test
  end

  private

  def load_model
    @check = Check.find(params[:id])
    @test = user.tests.find(@check.test_id) # security
  end

end
