module InstanceCounter

  attr_accessor :count

  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
    class << klass
      attr_accessor :count
    end
    klass.count = 0
  end

  module ClassMethods
    def instances
      @count
    end
  end

  module InstanceMethods
    def accounting_instances
      register_instance
    end

    private def register_instance
      puts self.class
      self.class.count += 1
    end
  end
end