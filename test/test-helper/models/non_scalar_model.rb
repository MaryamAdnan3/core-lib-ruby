# type_combinator_simple
#
# This file was automatically generated by APIMATIC v2.0
# ( https://apimatic.io ).

module TestComponent
  # This class contains non scalar types in oneOf/anyOf cases.
  class NonScalarModel < TestComponent::BaseModelTypeComb
    SKIP = Object.new
    private_constant :SKIP

    # TODO: Write general description for this method
    # @return [Object]
    attr_accessor :any_of_required

    # TODO: Write general description for this method
    # @return [Object]
    attr_accessor :one_of_req_nullable

    # TODO: Write general description for this method
    # @return [Object]
    attr_accessor :one_of_optional

    # TODO: Write general description for this method
    # @return [Object]
    attr_accessor :any_of_opt_nullable

    # A mapping from model property names to API property names.
    def self.names
      @_hash = {} if @_hash.nil?
      @_hash['any_of_required'] = 'anyOfRequired'
      @_hash['one_of_req_nullable'] = 'oneOfReqNullable'
      @_hash['one_of_optional'] = 'oneOfOptional'
      @_hash['any_of_opt_nullable'] = 'anyOfOptNullable'
      @_hash
    end

    # A mapping from model property names to types.
    def self.types
      @_types = {} if @_types.nil?
      @_types['any_of_required'] = 'anyOf(Atom, Orbit)'
      @_types['one_of_req_nullable'] = 'oneOf(Orbit, Vehicle)'
      @_types['one_of_optional'] = 'oneOf(Car, Morning, Atom)'
      @_types['any_of_opt_nullable'] = 'anyOf(Morning, Evening, Noon)'
      @_types
    end

    # An array for optional fields
    def self.optionals
      %w[
        one_of_optional
        any_of_opt_nullable
      ]
    end

    # An array for nullable fields
    def self.nullables
      %w[
        one_of_req_nullable
        any_of_opt_nullable
      ]
    end

    def initialize(any_of_required = nil,
                   one_of_req_nullable = nil,
                   one_of_optional = SKIP,
                   any_of_opt_nullable = SKIP)
      @any_of_required = any_of_required
      @one_of_req_nullable = one_of_req_nullable
      @one_of_optional = one_of_optional unless one_of_optional == SKIP
      @any_of_opt_nullable = any_of_opt_nullable unless any_of_opt_nullable == SKIP
    end

    # Creates an instance of the object from a hash.
    def self.from_hash(hash)
      return nil unless hash

      names.each do |key, value|
        has_default_value = false
        if !((hash.key? value) || (optionals.include? key)) && !has_default_value
          raise ArgumentError,
                "#{value} is not present in the provided hash"
        end
      end

      # Extract variables from the hash.
      any_of_required =
        if hash.key?('anyOfRequired')
          APIHelper.map_types(hash['anyOfRequired'],
                              types['any_of_required'])
        else
          SKIP
        end
      one_of_req_nullable =
        if hash.key?('oneOfReqNullable')
          APIHelper.map_types(hash['oneOfReqNullable'],
                              types['one_of_req_nullable'])
        else
          SKIP
        end
      one_of_optional =
        if hash.key?('oneOfOptional')
          APIHelper.map_types(hash['oneOfOptional'],
                              types['one_of_optional'])
        else
          SKIP
        end
      any_of_opt_nullable =
        if hash.key?('anyOfOptNullable')
          APIHelper.map_types(hash['anyOfOptNullable'],
                              types['any_of_opt_nullable'])
        else
          SKIP
        end

      # Create object from extracted values.
      NonScalarModel.new(any_of_required,
                         one_of_req_nullable,
                         one_of_optional,
                         any_of_opt_nullable)
    end
  end
end
