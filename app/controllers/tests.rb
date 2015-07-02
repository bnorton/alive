class Tests < Application
  before_action -> { @test = user.tests.find(params[:id]) }, :only => [:show, :edit, :update]

  def index
    @tests = user.tests
  end

  def show
  end

  def edit
  end

  def update
    @test.update(params.permit(*Test.allows))

    redirect_to test_path(@test)
  end

end
