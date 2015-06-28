class Worker
  def self.inherited(base)
    base.send(:include, Sidekiq::Worker)
  end

  # InstanceMethods

  # ClassMethods

end
