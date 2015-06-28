class Worker
  def self.inherited(base)
    base.send(:include, Sidekiq::Worker)
  end

  # InstanceMethods

  # ClassMethods
  def self.worker(options)
    if options[:queue] && options[:queue] != :exigent
      raise ':exigent is currently the only queue value'
    end

    sidekiq_options options
  end
end
