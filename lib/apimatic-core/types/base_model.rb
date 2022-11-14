module CoreLibrary
  # Base model.
  class BaseModel
    # Returns a Hash representation of the current object.
    def to_hash
      hash = {}
      instance_variables.each do |name|
        value = instance_variable_get(name)
        name = name[1..]
        key = self.class.names.key?(name) ? self.class.names[name] : name

        optional_fields = self.class.optionals
        nullable_fields = self.class.nullables
        if value.nil?
          next unless nullable_fields.include?(name)

          if !optional_fields.include?(name) && !nullable_fields.include?(name)
            raise ArgumentError,
                  "`#{name}` cannot be nil in `#{self.class}`. Please specify a valid value."
          end
        end

        hash[key] = nil
        unless value.nil?
          if respond_to?("to_#{name}")
            if (value.instance_of? Array) || (value.instance_of? Hash)
              params = [hash, key]
              hash[key] = send("to_#{name}", *params)
            else
              hash[key] = send("to_#{name}")
            end
          elsif value.instance_of? Array
            hash[key] = value.map { |v| v.is_a?(BaseModel) ? v.to_hash : v }
          elsif value.instance_of? Hash
            hash[key] = {}
            value.each do |k, v|
              hash[key][k] = v.is_a?(BaseModel) ? v.to_hash : v
            end
          else
            hash[key] = value.is_a?(BaseModel) ? value.to_hash : value
          end
        end
      end
      hash
    end

    # Returns a JSON representation of the curent object.
    def to_json(options = {})
      hash = to_hash
      hash.to_json(options)
    end

    # Use to allow additional model properties.
    def method_missing(method_sym, *arguments, &block)
      method = method_sym.to_s
      if method.end_with? '='
        instance_variable_set(format('@%s', [method.chomp('=')]),
                              arguments.first)
      elsif instance_variable_defined?("@#{method}") && arguments.empty?
        instance_variable_get("@#{method}")
      else
        super
      end
    end

    # Override for additional model properties.
    def respond_to_missing?(method_sym, include_private = false)
      instance_variable_defined?("@#{method_sym}") ? true : super
    end
  end
end