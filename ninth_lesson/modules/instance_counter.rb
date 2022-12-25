# frozen_string_literal: true

module InstanceCounter
  def self.included(klass)
    klass.extend ClassMethods
    super klass
  end

  private

  def register_instance
    self.class.instances unless self.class.instances
    self.class.instances += 1
  end

  module ClassMethods
    attr_accessor :instances
    def instances
      @instances ||= 0
    end
  end
end
