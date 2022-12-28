require 'apimatic_core'
require_relative 'exceptions/exception_with_string_exception'
require_relative 'exceptions/global_test_exception'
require_relative 'exceptions/custom_error_response_exception'
require_relative 'exceptions/nested_model_exception'
require_relative 'exceptions/enum_in_exception'
require_relative 'http/http_client_mock'
require_relative 'models/test_logger'
require_relative 'models/test_o_auth'
require_relative 'models/test_o_auth_exception'
require_relative 'models/person'
require_relative 'models/base_model'
require_relative 'models/employee'
require_relative 'models/attributes_and_elements'
require_relative 'models/atom'
require_relative 'models/morning'
require_relative 'models/evening'
require_relative 'models/vehicle'
require_relative 'models/orbit'
require_relative 'models/non_scalar_model'
require_relative 'models/car'
require_relative 'models/noon'

module TestComponent
  # An enum for SDK environments.
  class Environment
    ENVIRONMENT = [
      TESTING = 'testing'.freeze
    ].freeze
  end

  # An enum for API servers.
  class Server
    SERVER = [
      DEFAULT = 'default'.freeze,
      TEST_SERVER = 'test_server'.freeze
    ].freeze
  end

  # This is factor class, responsible for the creation of mocked components
  class MockHelper
    include CoreLibrary

    # All the environments the SDK can run in.
    ENVIRONMENTS = {
      Environment::TESTING => {
        Server::DEFAULT => 'http://localhost:3000',
        Server::TEST_SERVER => 'https://google.com'
      }
    }.freeze

    def self.test_token
      "KJGHGHFDFGH6757FGDFH67FTDFH567FGDHGDGFDC"
    end

    def self.test_server
      "https://google.com"
    end

    def self.default_path
      "/default_path"
    end

    def self.create_response(status_code: nil, reason_phrase: nil, headers: nil, raw_body: nil, request: nil)
      HttpResponse.new(status_code, reason_phrase, headers, raw_body, request)
    end

    def self.create_request(http_method: nil, query_url: nil, headers: {}, parameters: {}, context: {})
      HttpRequest.new(http_method, query_url, headers: headers, parameters: parameters, context: context)
    end

    def self.get_global_errors
      {
        'default' => ErrorCase.new.description('Invalid response.').exception_type(ApiException),
        '412' => ErrorCase.new.description('Precondition Failed').exception_type(NestedModelException),
        '450' => ErrorCase.new.description('caught global exception').exception_type(CustomErrorResponseException),
        '452' => ErrorCase.new.description('global exception with string').exception_type(ExceptionWithStringException),
      }
    end

    def self.create_logger(logger: nil)
      EndpointLogger.new logger
    end

    def self.create_client_configuration(http_callback: nil)
      HttpClientConfiguration.new(http_client: HttpClientMock.new, http_callback: http_callback)
    end

    def self.create_global_config_with_auth(raiseException, http_callback: nil)
      auth_managers = {}

      if(raiseException == true)
        auth_managers['test_global'] = TestOAuthException.new
      else
        auth_managers['test_global'] = TestOAuth.new
      end

      GlobalConfiguration.new(client_configuration: create_client_configuration(http_callback: http_callback))
                         .base_uri_executor(method(:get_base_uri))
                         .global_errors(get_global_errors)
                         .auth_managers(auth_managers)
                         .sdk_module(CoreLibrary)
    end

    def self.create_global_configurations(http_callback: nil)
      GlobalConfiguration.new(client_configuration: create_client_configuration(http_callback: http_callback))
                         .base_uri_executor(method(:get_base_uri))
                         .global_errors(get_global_errors)
                         .sdk_module(CoreLibrary)
    end

    def self.create_global_configurations_without_client
      GlobalConfiguration.new
                         .base_uri_executor(method(:get_base_uri))
                         .global_errors(get_global_errors)
    end

    def self.create_global_configurations_with_headers(http_callback: nil)
      GlobalConfiguration.new(client_configuration: create_client_configuration(http_callback: http_callback))
                         .base_uri_executor(method(:get_base_uri))
                         .global_errors(get_global_errors)
                         .global_headers({ "globalHeader": "value" })
                         .additional_headers({ "additionalHeader": "value" })
    end

    def self.get_base_uri(server = Server::DEFAULT)
      ENVIRONMENTS[Environment::TESTING][server]
    end

    def self.create_basic_request_builder
      RequestBuilder.new
                    .endpoint_logger(MockHelper::create_logger)
                    .server(Server::DEFAULT)
                    .path(default_path)
                    .global_configuration(MockHelper.create_global_configurations)
    end

    def self.create_basic_request_builder_with_global_headers
      RequestBuilder.new
                    .endpoint_logger(MockHelper::create_logger)
                    .server(Server::DEFAULT)
                    .path(default_path)
                    .global_configuration(MockHelper.create_global_configurations_with_headers)
    end

    def self.create_basic_request_builder_with_auth(raiseException)
      RequestBuilder.new
                    .endpoint_logger(MockHelper::create_logger)
                    .server(Server::DEFAULT)
                    .path(default_path)
                    .global_configuration(MockHelper.create_global_config_with_auth(raiseException))
    end

    def self.new_parameter(value, key: nil)
      Parameter.new.
        key(key).
        value(value)
    end
    def self.get_person_model
      person = Person.new("H # 531, S # 20", 23, '2016-03-13',
                          DateTimeHelper.from_rfc3339('2016-03-13T12:52:32.123Z'), "Jone", "1234",)
      return person
    end

    def self.get_attributes_elements_model
      AttributesAndElements.new('string-attr', 2, 'string-element', 23)
    end

    def self.get_attributes_elements_model_with_datetime
      AttributesAndElements.new('string-attr', 2, 'string-element',
                                DateTimeHelper.from_unix(1484719381))
    end
  end
end
