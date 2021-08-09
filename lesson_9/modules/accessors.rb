module Accessors

  def self.included(klass)
    klass.extend ClassMethods
  end


  module ClassMethods
    def self.extended(klass)
      class << klass
        attr_accessor :variables_history
      end
    end

    def attr_accessor_with_history(*args)
      @variables_history ||= {}
      args.each do |argv|
        get_argv argv
        save_set_argv argv, self.variables_history
        argv_history argv, self.variables_history
      end
    end

    def strong_attr_accessor(argv, class_type)
      get_argv argv
      strong_set_argv argv, class_type
    end

    private

    def get_argv(argv)
      define_method(argv) do
        instance_variable_get "@#{argv}"
      end
    end

    def save_set_argv(argv, history_storage)
      define_method("#{argv}=") do |value|
        self.class.send(:set_argv, argv, value)
        self.class.send(:save_value_argv, argv, value, history_storage)
      end
    end

    def strong_set_argv(argv, class_type)
      define_method("#{argv}=") do |value|
        value.instance_of?(class_type) ? self.class.send(:set_argv, argv, value) : raise('Некорректный класс!')
      end
    end

    def set_argv(argv, value)
      instance_variable_set "@#{argv}", value
    end

    def save_value_argv(argv, value, history_storage)
      variable_history = history_storage[argv]
      variable_history.nil? ? (history_storage[argv] = [value]) : variable_history << value
    end

    def argv_history(argv, history_storage)
      define_method("#{argv}_history") do
        history_storage[argv]
      end
    end
  end
end