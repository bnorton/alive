class Check < Model
  attrs String => { :key => :k, :value => :v },
    Integer => { :index => :i },
    Enum => { :kind => Kind::Check::VALUES }

  validates :test_id, :presence => true

  belongs_to :test

  after_create -> { TestWorker.perform_async(test.id) }, :if => -> { index == 1 }

  def decorator
    "Check_#{kind}".classify.constantize
  end

  private

  def defaults_before_create
    test.update(:check_index => test.check_index+1)

    self.index = test.check_index
  end
end
