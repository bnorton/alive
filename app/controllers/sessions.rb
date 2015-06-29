class Sessions < Application
  skip_before_filter :authenticate!

  def new
  end

  def create
    user = User.where(:email => params[:email]).first
    success = user && user.password_is?(params[:password]) &&
      set_cookie(:id, user.id) && set_cookie(:token, user.token)

    redirect_to(success ? dashboard_path : login_path)
  end

  def destroy
    set_cookie(:id, '') && set_cookie(:token, '')

    redirect_to(login_path)
  end
end
