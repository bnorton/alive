class Tests < Application
  before_action :load_test, :only => [:show, :edit, :update]

  def index
    @tests = user.tests
  end

  def new
  end

  def create
    @test = user.tests.new

    update
  end

  def show
  end

  def edit
  end

  def update
    @test.update(params.permit(*Test.allows))

    redirect_to test_path(@test)
  end

  private

  def load_test
    @test = user.tests.find(params[:id])
  end

end
