class Tests < Application
  def index
    @tests = user.tests
  end

  def show
    @test = user.tests.find(params[:id])
  end
end
