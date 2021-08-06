# frozen_string_literal: true

module InstanceCounter
  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end

  module ClassMethods
    def self.extended(klass)
      class << klass
        attr_accessor :instances
      end
    end

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    def accounting_instances
      register_instance
    end

    private

    def register_instance
      self.class.instances ||= 0
      self.class.instances += 1
    end
  end
end
