module Validation

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def validations
      @validations ||= []
    end

    def validate(name, type, param = nil)
      @validations << { name: name, type: type, param: param }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |value|
        validation = "validate_#{value[:type]}"
        param = value[:param]
        value = instance_variable_get("@#{value[:name]}".to_sym)
        send(validation, value, param)
      end
    end

    def valid?  
      validate!
      true
    rescue
      false
    end

    private

    def validate_presence(value)
      raise 'Не может быть пустым!' if value.nil? || value.strip.empty?
    end

    def validate_format(value, format)
      raise 'Неверный формат!' if value.nil? || value !~ format
    end

    def validate_type(value, type)
      raise 'Неверный тип!' unless value.is_a?(type)
    end

  end

end