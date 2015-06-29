module TestHelper
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def sign_in(user)
      if respond_to?(:controller)
        allow(controller).to receive(:user).and_return(user)
      else
        allow_any_instance_of(Application).to receive(:user).and_return(user)
      end
    end

    def sign_out
      if respond_to?(:controller)
        allow(controller).to receive(:user).and_return(nil)
      else
        allow_any_instance_of(Application).to receive(:user).and_return(nil)
      end
    end

  end

end
