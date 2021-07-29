module InstanceCounter

  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end

  module ClassMethods

    # Думаю это верное решение, сначала не знал как передать ссылку на
    # класс в модуль, поэтому иниициализировал в self.included
    def self.extended(klass)
      class << klass
        attr_accessor :count
      end
    end

    def instances
      @count ||= 0 # Забыл про эту фичу - как в JS ;)
    end
  end

  module InstanceMethods
    def accounting_instances
      register_instance
    end

    private def register_instance
      self.class.count += 1
    end
  end
end