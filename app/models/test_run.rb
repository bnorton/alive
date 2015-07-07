class TestRun < Model
  attrs String => { :headers => :h, :body => :b },
    Time => { :at => :a, :run_at => :ra },
    Integer => { :code => :c },
    Float => { :duration => :d }

  validates :user_id, :test_id, :presence => true

  belongs_to :user, :test
  belongs_to :failed_check, :class_name => 'Check'

  after_create -> { TestRunWorker.perform_async(id) }

  private

  def defaults_before_create
    self.run_at = Time.now
  end

end
