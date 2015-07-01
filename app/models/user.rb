class User < Model
  attrs String => { :email => :e, :password => :p, :salt => :s, :token => :t },
    Integer => { :test_index => :ti }

  validates :email, :password, :presence => true

  has_many :tests

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
  end

end
