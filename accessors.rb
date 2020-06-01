module Accessors

  def self.included(base)
  	base.extend ClassMethods
  end  

  module ClassMethods

    def attr_accessor_with_history(*params)
      params.each do |param| 
        var_param = "@#{param}".to_sym
        define_method(param) { instance_variable_get(var_param) }
        define_method("#{param}=".to_sym) { |value| instance_variable_set(var_param, value) }
      end
    end
  
    def strong_attr_accessor(var_param, var_class)
      var, var_get, var_set = ["@#{var_name}", var_name, "#{var_name}="].map(&:to_sym)

      define_method(var_get) { instance_variable_get(var) }

      define_method(var_set) do |value|
        unless value.is_a?(var_class)
          raise "#{var_name} должен быть экземпляром класса #{var_class}!"
        end
        instance_variable_set(var, value)
      end
    end
  
  end

end  
