module RequestHelper
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module InstanceMethods
    def wait_for_ajax
      starting = Time.now
      loop do
        break if page.evaluate_script('Object.keys(test.ajaxRequests).length == 0')
        raise "Waited too long for ajax requests to finish #{page.evaluate_script('JSON.stringify(test.ajaxRequests)')}" if (Time.now - starting) > 2
        sleep 0.05
      end
    end

  end

  module ClassMethods

  end
end
