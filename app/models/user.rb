class User < Model
  attrs String => { :email => :e }

  validates :email, :presence => true

end
