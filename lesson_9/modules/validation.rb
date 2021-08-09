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
      @validate_storage ||= {}
      validate_actions = {
        presence: -> (att_val) { presence att_val  }, format: -> (att_val) { format att_val, option },
        type: -> (att_val) { type att_val, option }
      }
      if @validate_storage[att_name].nil?
        @validate_storage[att_name] = [validate_actions[validate_type]]
      else
        @validate_storage[att_name] << validate_actions[validate_type]
      end
    end

    private

    def presence(attr_value)
      attr_value.nil? || attr_value.eql?("") ? raise("Передано nil значение или пустая строка у атрибута!") : true
    end

    def format(attr_value, regexp)
      regexp.match?(attr_value) ? true : raise('Значение не сопоставляется с переданным regexp выражением')
    end

    def type(attr_value, class_type)
      attr_value.instance_of?(class_type) ? true : raise('Передан не соответствующий тип')
    end
  end

  module InstanceMethods
    def validate!
      self.class.validate_storage.each do |attr_name, actions|
        actions.each do |action|
          action.call(ins_attr_value(attr_name))
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    def ins_attr_value(attr_name)
      self.instance_variable_get("@#{attr_name}")
    end
  end
end