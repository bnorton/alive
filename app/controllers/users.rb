class Users < Application
  skip_before_action :authenticate!

  def new
  end

  def create
    user = User.new(params.permit(:email, :password))
    success = user.save && set_cookie(:id, user.id) && set_cookie(:token, user.token)

    redirect_to(success ? dashboard_index_path : sign_up_path)
  end
end
