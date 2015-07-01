class Test < Model
  attrs String => { :url => :u, :headers => :h, :body => :b },
    Time => { :at => :a },
    Integer => { :index => :i, :interval => :n, :last_code => :lc, :check_index => :ci },
    Float => { :last_duration => :ld },
    Mongoid::Boolean => { :json => :j, :last_success => :ls },
    Enum => { :breed => %w(get post options head put patch delete) }

  validates :user_id, :url, :presence => true

  belongs_to :user
  has_many :checks

  private

  def defaults_before_create
    user.update(:test_index => user.test_index+1)

    self.index = user.test_index
    self.at = Time.now
    self.interval = 6.hours if self.interval.zero?
    self.last_success = true
  end
end
