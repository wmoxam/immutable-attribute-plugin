module ActiveRecord
  class ImmutableAttributeError < ActiveRecordError
    def initialize(message=nil)
      super(message || 'Cannot modify immutable attribute')
    end
  end
end

module EnsuresImmutabilityOf
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def ensures_immutability_of(*attr_names)
      configuration = { :message => "Attribute cannot be changed" }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

      attr_names.each do |attr_name|
        setter_name = "#{attr_name}="
        ub_overwritten_setter = (method_defined?(setter_name) ? instance_method(setter_name) : nil)
        ub_attr_getter = (method_defined?(attr_name) ? instance_method(attr_name) : nil)
        define_method setter_name do |new_value|
          getter = Proc.new { ub_attr_getter ? ub_attr_getter.bind(self).call : read_attribute(attr_name) }
          return if getter.call == new_value
          if getter.call.nil? || (getter.call.is_a?(Array) && getter.call.empty?)
            ub_overwritten_setter ? ub_overwritten_setter.bind(self).call(new_value) : write_attribute(attr_name, new_value)
          else
            raise(ActiveRecord::ImmutableAttributeError, configuration[:message])
          end
        end
      end
    end
  end
end
