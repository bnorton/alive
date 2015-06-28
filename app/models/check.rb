class Check < Model
  attrs String => { :key => :k, :value => :v },
    Enum => { :kind => Kind::Check::VALUES }

  validates :test_id, :presence => true

  belongs_to :test

  def decorator
    "Check_#{kind}".classify.constantize
  end
end
