class Test < Model
  attrs String => { :url => :u, :headers => :h, :body => :b },
    Integer => { :interval => :n },
    Mongoid::Boolean => { :json => :j },
    Time => { :at => :a },
    Enum => { :breed => %w(get post options head put patch delete) }

  validates :user_id, :url, :presence => true

  belongs_to :user

  after_create -> { TestWorker.perform_async(id) }

  private

  def defaults_before_create
    self.interval = 6.hours if self.interval.zero?
  end
end
