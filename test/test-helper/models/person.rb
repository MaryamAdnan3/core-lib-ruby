# tester
#
# This file was automatically generated by APIMATIC v2.0
# ( https://apimatic.io ).

require 'date'

module TestComponent
  include CoreLibrary
  # Person Model.
  class Person < TestComponent::BaseModel
    SKIP = Object.new
    private_constant :SKIP

    # TODO: Write general description for this method
    # @return [String]
    attr_accessor :address

    # TODO: Write general description for this method
    # @return [Integer]
    attr_accessor :age

    # TODO: Write general description for this method
    # @return [Date]
    attr_accessor :birthday

    # TODO: Write general description for this method
    # @return [DateTime]
    attr_accessor :birthtime

    # TODO: Write general description for this method
    # @return [String]
    attr_accessor :name

    # TODO: Write general description for this method
    # @return [String]
    attr_accessor :uid

    # TODO: Write general description for this method
    # @return [String]
    attr_accessor :person_type

    # Discriminators mapping.
    def self.discriminators
      if @_discriminators.nil?
        @_discriminators = {}
        @_discriminators['Empl'] = Employee
      end
      @_discriminators
    end

    # A mapping from model property names to API property names.
    def self.names
      @_hash = {} if @_hash.nil?
      @_hash['address'] = 'address'
      @_hash['age'] = 'age'
      @_hash['birthday'] = 'birthday'
      @_hash['birthtime'] = 'birthtime'
      @_hash['name'] = 'name'
      @_hash['uid'] = 'uid'
      @_hash['person_type'] = 'personType'
      @_hash
    end

    # An array for optional fields
    def self.optionals
      %w[
        person_type
      ]
    end

    # An array for nullable fields
    def self.nullables
      []
    end

    def initialize(address = nil,
                   age = nil,
                   birthday = nil,
                   birthtime = nil,
                   name = nil,
                   uid = nil,
                   person_type = 'Per',
                   additional_properties = {})
      @address = address
      @age = age
      @birthday = birthday
      @birthtime = birthtime
      @name = name
      @uid = uid
      @person_type = person_type unless person_type == SKIP

      # Add additional model properties to the instance.
      additional_properties.each do |_name, _value|
        instance_variable_set("@#{_name}", _value)
      end
    end

    # Creates an instance of the object from a hash.
    def self.from_hash(hash)
      return nil unless hash

      # Delegate unboxing to another function if a discriminator
      # value for a child class is present.
      unboxer = discriminators[hash['personType']]
      return unboxer.send(:from_hash, hash) if unboxer

      # Extract variables from the hash.
      address = hash.key?('address') ? hash['address'] : nil
      age = hash.key?('age') ? hash['age'] : nil
      birthday = hash.key?('birthday') ? hash['birthday'] : nil
      birthtime = if hash.key?('birthtime')
                    ( CoreLibrary::DateTimeHelper.from_rfc3339(hash['birthtime']) if hash['birthtime'])
                  end
      name = hash.key?('name') ? hash['name'] : nil
      uid = hash.key?('uid') ? hash['uid'] : nil
      person_type = hash['personType'] ||= 'Per'

      # Clean out expected properties from Hash.
      names.each_value { |k| hash.delete(k) }

      # Create object from extracted values.
      Person.new(address,
                 age,
                 birthday,
                 birthtime,
                 name,
                 uid,
                 person_type,
                 hash)
    end

    def to_birthtime
      TestComponent::DateTimeHelper.to_rfc3339(birthtime)
    end
  end
end
