class Tests < Application
  before_action :load_test, :only => [:show, :edit, :update]

  def index
    @tests = user.tests
  end

  def new
  end

  def create
    @model = user.tests.new

    update
  end

  def show
  end

  def edit
  end

  def update
    @model.update(params.permit(*Test.allows))

    respond
  end

  private

  def load_test
    @model = user.tests.find(params[:id])
  end

end
