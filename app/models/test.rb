class Test < Model
  attrs String => { :name => :m, :url => :u, :headers => :h, :body => :b },
    Time => { :at => :a },
    Integer => { :index => :i, :interval => :n, :check_index => :ci },
    Mongoid::Boolean => { :json => :j,  },
    Enum => { :breed => %w(get post options head put patch delete) }

  attrs Time => { :last_at => :la }, Integer => { :last_code => :lc }, # Cache the most recent TestRun
    Float => { :last_duration => :ld }, Mongoid::Boolean => { :last_success => :ls }

  allow :name, :interval, :breed, :url, :headers, :body

  validates :user_id, :url, :presence => true

  belongs_to :user
  has_many :checks, :test_runs

  private

  def defaults_before_create
    user.update(:test_index => user.test_index+1)

    self.index = user.test_index
    self.at = Time.now
    self.interval = 6.hours if self.interval.zero?
    self.last_success = true
  end
end
