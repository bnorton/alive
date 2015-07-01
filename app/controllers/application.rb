class Application < ActionController::Base
  def self.inherited(base)
    BasicObject.const_set("#{base.name}Controller", base)
  end

  protect_from_forgery :with => :exception

  before_action :authenticate!

  helper_method :cookie, :user

  def set_cookie(name, value)
    cookies.encrypted["user:#{name}"] = value.to_s
  end

  def cookie(name)
    cookies.encrypted["user:#{name}"]
  end

  def user
    defined?(@user) ? @user : (@user = User.where(:id => cookie(:id), :token => cookie(:token)).first)
  end

  def authenticate!
    begin
      raise 'User not authenticated : ' +
        { :cookie => { :id => cookie(:id), :token => cookie(:token) },
          :headers => headers,
          :params => params
        }.to_json
    end unless user.present?
  end
end
