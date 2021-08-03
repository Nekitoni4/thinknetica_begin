module InstanceCounter

  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end

  module ClassMethods

    
    def self.extended(klass)
      class << klass
        attr_accessor :count
      end
    end

    def instances
      @count ||= 0
    end
  end

  module InstanceMethods
    def accounting_instances
      register_instance
    end

    private def register_instance
      self.class.count ||= 0
      self.class.count += 1
    end
  end
end