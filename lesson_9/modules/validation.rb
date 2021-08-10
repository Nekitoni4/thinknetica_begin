module Validation

  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end

  module ClassMethods

    def self.extended(klass)
      class << klass
        attr_accessor :validate_storage
      end
    end

    def validate(att_name, validate_type, option = nil)
      @validate_storage ||= []
      @validate_storage << {
        validate_type: validate_type, var: att_name, param: option
      }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validate_storage.each do |validate_action|
        validate_type, var, param = validate_action.values
        attr_value = send(:ins_attr_value, var)
        send(validate_type, attr_value, param)
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def presence(attr_value, _)
      attr_value.nil? || attr_value.eql?('') ? raise('Передано nil значение или пустая строка у атрибута!') : true
    end

    def format(attr_value, regexp)
      regexp.match?(attr_value) ? true : raise('Значение не сопоставляется с переданным regexp выражением')
    end

    def type(attr_value, class_type)
      attr_value.instance_of?(class_type) ? true : raise('Передан не соответствующий тип')
    end

    def ins_attr_value(attr_name)
      instance_variable_get("@#{attr_name}")
    end
  end
end
