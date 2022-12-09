module InstanceCounter
  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end
    
    private def increment_instances
        @instances += 1
    end
  end

  module InstanceMethods
    protected def register_instance
      self.class.instances
      self.class.send(:increment_instances)
    end
  end
end