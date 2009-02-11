module Huberry
  module HattrAccessor
    class MissingAttributeError < StandardError; self; end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
    
      def hattr_accessor(*attrs)
        options = attrs.last.is_a?(Hash) ? attrs.pop : {}
      
        raise MissingAttributeError, 'Must specify the :attribute option with the name of an attribute which will store the hash' if options[:attribute].nil?
      
        # Defines a type casting getter method for each attribute
        #
        attrs.each do |name|
          setter = (name.to_s + '=').to_sym
          define_method(name) {self.get_hattr_attribute_value(options[:attribute],name, options[:type])}
          define_method(setter) {|val| self.set_hattr_attribute_value(options[:attribute],name, val, options[:type])}
        end
      
        unless instance_methods.include?(options[:attribute].to_s)
          define_method(options[:attribute]) do
            instance_variable_set("@#{options[:attribute]}".to_sym,{}) unless instance_variable_get("@#{options[:attribute]}".to_sym).kind_of?(Hash)
            instance_variable_get("@#{options[:attribute]}".to_sym)
          end
        end

        # Create the writer for #{options[:attribute]} unless it exists already
        #
        attr_writer options[:attribute] unless instance_methods.include?("#{options[:attribute]}=")
      
      end
      
    end
    
    protected

    def set_hattr_attribute_value(hash_attribute,attribute, val, type)
      converted_val = convert_to_type(val, type)
      update_hash_attribute_value(hash_attribute,attribute,converted_val)
    end

    def get_hattr_attribute_value(hash_attribute,attribute, type)
      convert_to_type(get_hashed_attribute(hash_attribute)[attribute], type)
    end
    
    def convert_to_type(value, type)
      case type
        when :string
          value.to_s
        when :integer
          value.to_i
        when :float
          value.to_f
        when :boolean
          ![false, nil, 0, '0', ''].include?(value)
        else
          value
      end
    end
    
    def get_hashed_attribute(hash_attribute)
      send("#{hash_attribute}".to_sym)
    end
    
    def update_hash_attribute_value(hash_attribute,attribute,val)
      get_hashed_attribute(hash_attribute)[attribute] = val
    end
    
  end
end

Object.send :include, Huberry::HattrAccessor