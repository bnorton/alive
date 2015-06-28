class Test < Model
  attrs String => { :url => :u, :headers => :h, :body => :b },
    Integer => { :index => :i, :interval => :n, :check_index => :ci },
    Mongoid::Boolean => { :json => :j },
    Time => { :at => :a },
    Enum => { :breed => %w(get post options head put patch delete) }

  validates :user_id, :url, :presence => true

  belongs_to :user

  private

  def defaults_before_create
    user.update(:test_index => user.test_index+1)

    self.index = user.test_index
    self.interval = 6.hours if self.interval.zero?
  end
end
