class User < Model
  attrs String => { :email => :e, :password => :p, :salt => :s, :token => :t },
    Integer => { :test_index => :ti },
    Mongoid::Boolean => { :notify_email => :ne, :notify_slack => :ns }

  allow :notify_email, :notify_slack

  validates :email, :password, :presence => true

  has_many :tests, :test_runs

  def password_is?(string)
    password == Digest::SHA256.hexdigest("#{string}|#{salt}")
  end

  def password=(string)
    self[:salt] = Base62.token
    self[:password] = string.presence && Digest::SHA256.hexdigest("#{string}|#{salt}")
  end

  private

  def defaults_before_create
    self.token = Base62.token
    self.notify_email = true
  end

end
