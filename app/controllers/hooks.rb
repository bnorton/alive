class Hooks < Application
  before_action :load_test, :only => [:new, :create]
  before_action :load_model, :only => [:edit, :update]

  def new
  end

  def create
    @hook = @model.hooks.new

    update
  end

  def edit
  end

  def update
    parsed_params = parse_checkboxes params.permit(*Hook.allows), :include_response, :enabled
    @hook.update(parsed_params)

    respond @hook
  end

  private

  def load_test
    @model = user.tests.find(params[:test_id])
  end

  def load_model
    @hook = Hook.find(params[:id])
    @model = user.tests.find(@hook.test_id) # security
  end

end