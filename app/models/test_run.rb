class TestRun < Model
  attrs String => { },
    Time => { :at => :a, :run_at => :ra },
    Float => { :duration => :d }

  validates :user_id, :test_id, :presence => true

  belongs_to :user, :test
  belongs_to :failed_check, :class_name => 'Check'

end
