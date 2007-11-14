module EnsuresImmutabilityOf
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def ensures_immutability_of(*attr_names)
      configuration = { :message => "Attribute cannot be changed" }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

      attr_names.each do |attr_name|
        define_method "#{attr_name}=" do |new_value|
	  return if read_attribute(attr_name) == new_value
          read_attribute(attr_name).nil? ? write_attribute(attr_name, new_value) :  raise(RuntimeError, configuration[:message])
        end
      end
    end
  end
end
