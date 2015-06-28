class User < Model
  attrs String => { :email => :e },
    Integer => { :test_index => :ti }

  validates :email, :presence => true

end
