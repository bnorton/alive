class Check < Model
  attrs String => { :key => :k, :value => :v },
    Integer => { :index => :i },
    Enum => { :kind => Kind::Check::VALUES }

  allow :key, :value, :kind

  validates :test_id, :presence => true

  belongs_to :test

  def decorator
    "Check_#{kind}".classify.constantize
  end

  private

  def defaults_before_create
    test.update(:check_index => test.check_index+1)

    self.index = test.check_index
  end
end
