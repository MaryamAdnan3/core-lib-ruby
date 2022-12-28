module CoreLibrary
  # This class is for handling of the http response for an API call.
  class ResponseHandler
    def initialize
      @deserializer = nil
      @convertor = nil
      @deserialize_into = nil
      @is_api_response = false
      @is_nullify404 = false
      @local_errors = {}
      @datetime_format = nil
      @is_xml_response = false
      @xml_attribute = nil
      @endpoint_name_for_logging = nil
      @endpoint_logger = nil
      @is_primitive_response = false
      @is_date_response = false
      @is_response_array = false
      @is_response_void = false
      @type_group = nil
    end

    # Sets deserializer for the response.
    # @param [Method] deserializer The method to be called for deserializing the response.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def deserializer(deserializer)
      @deserializer = deserializer
      self
    end

    # Sets converter for the response.
    # @param [Method] convertor The method to be called while converting the deserialized response.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def convertor(convertor)
      @convertor = convertor
      self
    end

    # Sets the model to deserialize into.
    # @param [Method] deserialize_into The method to be called while deserializing.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def deserialize_into(deserialize_into)
      @deserialize_into = deserialize_into
      self
    end

    # Sets local_errors hash key value.
    # @param [String] error_code The error code to check against.
    # @param [String] description The reason for the exception.
    # @param [ApiException] exception_type The type of the exception to raise.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def local_error(error_code, description, exception_type)
      @local_errors[error_code.to_s] = ErrorCase.new.description(description).exception_type(exception_type)
      self
    end

    # Sets the datetime format.
    # @param [DateTimeFormat] datetime_format The date time format to deserialize against.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def datetime_format(datetime_format)
      @datetime_format = datetime_format
      self
    end

    # Set the xml_attribute property.
    # @param [XmlAttributes] xml_attribute The xml configuration if the response is XML.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def xml_attribute(xml_attribute)
      @xml_attribute = xml_attribute
      self
    end

    # Sets the endpoint_name_for_logging property.
    # @param [String] endpoint_name_for_logging The endpoint method name to be used while logging.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def endpoint_name_for_logging(endpoint_name_for_logging)
      @endpoint_name_for_logging = endpoint_name_for_logging
      self
    end

    # Sets endpoint logger to be used.
    # @param [EndpointLogger] endpoint_logger The logger to be used for logging API call steps.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def endpoint_logger(endpoint_logger)
      @endpoint_logger = endpoint_logger
      self
    end

    # Sets the is_primitive_response property.
    # @param [Boolean] is_primitive_response Flag if the response is of primitive type.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    # rubocop:disable Naming/PredicateName
    def is_primitive_response(is_primitive_response)
      @is_primitive_response = is_primitive_response
      self
    end

    # Sets the is_api_response property.
    # @param [Boolean] is_api_response Flag to return the complete http response.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def is_api_response(is_api_response)
      @is_api_response = is_api_response
      self
    end

    # Sets the is_nullify404 property.
    # @param [Boolean] is_nullify404 Flag to return early in case of 404 error code.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def is_nullify404(is_nullify404)
      @is_nullify404 = is_nullify404
      self
    end

    # Set the is_xml_response property.
    # @param [Boolean] is_xml_response Flag if the response is XML.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def is_xml_response(is_xml_response)
      @is_xml_response = is_xml_response
      self
    end

    # Sets the is_date_response property.
    # @param [Boolean] is_date_response Flag if the response is a date.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def is_date_response(is_date_response)
      @is_date_response = is_date_response
      self
    end

    # Sets the is_response_array property.
    # @param [Boolean] is_response_array Flag if the response is an array.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def is_response_array(is_response_array)
      @is_response_array = is_response_array
      self
    end

    # Sets the is_response_void property.
    # @param [Boolean] is_response_void Flag if the response is void.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def is_response_void(is_response_void)
      @is_response_void = is_response_void
      self
    end
    # rubocop:enable Naming/PredicateName

    # Sets type group for the response.
    # @param [String] type_group The oneOf/anyOf type group template.
    # @return [ResponseHandler] An updated instance of ResponseHandler.
    def type_group(type_group)
      @type_group = type_group
      self
    end

    # Main method to handle the response with all the set properties.
    # @param [HttpResponse] response The response received.
    # @param [Hash] global_errors The global errors object.
    # @param [Module] sdk_module The module of the SDK core library is being used for.
    # @param [Boolean] should_symbolize_hash Flag to symbolize the hash during response deserialization.
    # @return [Object] The deserialized response of the API Call.
    # rubocop:disable Style/OptionalBooleanParameter
    def handle(response, global_errors, sdk_module, should_symbolize_hash = false)
      @endpoint_logger.info("Validating response for #{@endpoint_name_for_logging}.")

      # checking Nullify 404
      if response.status_code == 404 && @is_nullify404
        @endpoint_logger.info("Status code 404 received for #{@endpoint_name_for_logging}. Returning None.")
        return nil
      end

      # validating response if configured
      validate(response, global_errors)

      return if @is_response_void

      # applying deserializer if configured
      deserialized_value = apply_deserializer(response, sdk_module, should_symbolize_hash)

      # applying api_response if configured
      deserialized_value = apply_api_response(response, deserialized_value)

      # applying convertor if configured
      deserialized_value = apply_convertor(deserialized_value)

      deserialized_value
    end
    # rubocop:enable Style/OptionalBooleanParameter

    # Validates the response provided and throws an error from global_errors if it fails.
    # @param response The received response.
    # @param global_errors Global errors hash.
    def validate(response, global_errors)
      return unless response.status_code < 200 || response.status_code > 208

      actual_status_code = response.status_code.to_s

      contains_local_errors = (!@local_errors.nil? and !@local_errors[actual_status_code].nil?)
      if contains_local_errors
        error_case = @local_errors[actual_status_code]
        raise error_case.get_exception_type.new error_case.get_description, response
      end

      contains_local_default_error = (!@local_errors.nil? and !@local_errors['default'].nil?)
      if contains_local_default_error
        error_case = @local_errors['default']
        raise error_case.get_exception_type.new error_case.get_description, response
      end

      contains_global_errors = (!global_errors.nil? and !global_errors[actual_status_code].nil?)
      if contains_global_errors
        error_case = global_errors[actual_status_code]
        raise error_case.get_exception_type.new error_case.get_description, response
      end

      error_case = global_errors['default']
      raise error_case.get_exception_type.new error_case.get_description, response unless error_case.nil?
    end

    # Applies xml deserializer to the response.
    def apply_xml_deserializer(response)
      unless @xml_attribute.get_array_item_name.nil?
        return @deserializer.call(response.raw_body, @xml_attribute.get_root_element_name,
                                  @xml_attribute.get_array_item_name, @deserialize_into, @datetime_format)
      end

      @deserializer.call(response.raw_body, @xml_attribute.get_root_element_name, @deserialize_into, @datetime_format)
    end

    # Applies deserializer to the response.
    # @param sdk_module Module of the SDK using the core library.
    # @param [Boolean] should_symbolize_hash Flag to symbolize the hash during response deserialization.
    def apply_deserializer(response, sdk_module, should_symbolize_hash)
      return apply_xml_deserializer(response) if @is_xml_response
      return response.raw_body if @deserializer.nil?

      if !@type_group.nil?
        @deserializer.call(@type_group, response.raw_body, sdk_module, should_symbolize_hash)
      elsif @datetime_format
        @deserializer.call(response.raw_body, @datetime_format, @is_response_array, should_symbolize_hash)
      elsif @is_date_response
        @deserializer.call(response.raw_body, @is_response_array, should_symbolize_hash)
      elsif !@deserialize_into.nil? || @is_primitive_response
        @deserializer.call(response.raw_body, @deserialize_into, @is_response_array, should_symbolize_hash)
      else
        @deserializer.call(response.raw_body, should_symbolize_hash)
      end
    end

    # Applies API response.
    # @param response The actual HTTP response.
    # @param deserialized_value The deserialized value.
    def apply_api_response(response, deserialized_value)
      if @is_api_response
        errors = ApiHelper.map_response(deserialized_value, ['errors'])
        return ApiResponse.new(response, data: deserialized_value, errors: errors)
      end

      deserialized_value
    end

    # Applies converter to the response.
    # @param deserialized_value The deserialized value.
    def apply_convertor(deserialized_value)
      return @convertor.call(deserialized_value) unless @convertor.nil?

      deserialized_value
    end
  end
end
