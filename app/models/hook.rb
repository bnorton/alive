class Hook < Model
  attrs String => {:name => :n, :url => :u },
    Mongoid::Boolean => { :include_response => :ir, :enabled => :e  }

  allow :name, :url, :include_response, :enabled

  validates :test_id, :url, :name, :presence => true

  belongs_to :test

  private

  def defaults_before_create
    self.include_response = false unless self.include_response
    self.enabled = false unless self.enabled
  end
end
