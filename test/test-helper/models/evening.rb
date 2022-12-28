# type_combinator_simple
#
# This file was automatically generated by APIMATIC v2.0
# ( https://apimatic.io ).

module TestComponent
  # Course evening session
  class Evening < TestComponent::BaseModelTypeComb
    SKIP = Object.new
    private_constant :SKIP

    # Session start time
    # @return [String]
    attr_accessor :starts_at

    # Session end time
    # @return [String]
    attr_accessor :ends_at

    # Offer dinner during session
    # @return [TrueClass|FalseClass]
    attr_accessor :offer_dinner

    # Offer dinner during session
    # @return [String]
    attr_accessor :session_type

    # A mapping from model property names to API property names.
    def self.names
      @_hash = {} if @_hash.nil?
      @_hash['starts_at'] = 'startsAt'
      @_hash['ends_at'] = 'endsAt'
      @_hash['offer_dinner'] = 'offerDinner'
      @_hash['session_type'] = 'sessionType'
      @_hash
    end

    # A mapping from model property names to types.
    def self.types
      @_types = {} if @_types.nil?
      @_types['starts_at'] = 'String'
      @_types['ends_at'] = 'String'
      @_types['offer_dinner'] = 'TrueClass|FalseClass'
      @_types['session_type'] = 'String'
      @_types
    end

    # An array for optional fields
    def self.optionals
      %w[
        session_type
      ]
    end

    # An array for nullable fields
    def self.nullables
      []
    end

    def initialize(starts_at = nil,
                   ends_at = nil,
                   offer_dinner = nil,
                   session_type = 'Evening')
      @starts_at = starts_at
      @ends_at = ends_at
      @offer_dinner = offer_dinner
      @session_type = session_type unless session_type == SKIP
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
      starts_at = hash.key?('startsAt') ? hash['startsAt'] : nil
      ends_at = hash.key?('endsAt') ? hash['endsAt'] : nil
      offer_dinner = hash.key?('offerDinner') ? hash['offerDinner'] : nil
      session_type = hash['sessionType'] ||= 'Evening'

      # Create object from extracted values.
      Evening.new(starts_at,
                  ends_at,
                  offer_dinner,
                  session_type)
    end
  end
end
