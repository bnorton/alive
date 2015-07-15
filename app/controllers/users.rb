class Users < Application
  skip_before_action :authenticate!, :only => [:new, :create]

  html :new, :show

  def create
    user = User.new(params.permit(:email, :password))
    success = user.save && set_cookie(:id, user.id) && set_cookie(:token, user.token)

    redirect_to(success ? dashboard_index_path : sign_up_path)
  end

  def update
    params[:notify_email] = params[:notify_email] == 'on'
    params[:notify_slack] = params[:notify_slack] == 'on'

    user.update(params.permit(*User.allows))

    redirect_to settings_path
  end

end
