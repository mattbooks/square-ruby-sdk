module Square
  # ApplePayApi
  class ApplePayApi < BaseApi
    def initialize(config, http_call_back: nil)
      super(config, http_call_back: http_call_back)
    end

    # Activates a domain for use with Apple Pay on the Web and Square. A
    # validation
    # is performed on this domain by Apple to ensure that it is properly set up
    # as
    # an Apple Pay enabled domain.
    # This endpoint provides an easy way for platform developers to bulk
    # activate
    # Apple Pay on the Web with Square for merchants using their platform.
    # To learn more about Web Apple Pay, see
    # [Add the Apple Pay on the Web
    # Button](https://developer.squareup.com/docs/payment-form/add-digital-walle
    # ts/apple-pay).
    # @param [RegisterDomainRequest] body Required parameter: An object
    # containing the fields to POST for the request.  See the corresponding
    # object definition for field details.
    # @return [RegisterDomainResponse Hash] response from the API call
    def register_domain(body:)
      # Prepare query url.
      _query_builder = config.get_base_uri
      _query_builder << '/v2/apple-pay/domains'
      _query_url = APIHelper.clean_url _query_builder

      # Prepare headers.
      _headers = {
        'accept' => 'application/json',
        'content-type' => 'application/json; charset=utf-8'
      }

      # Prepare and execute HttpRequest.
      _request = config.http_client.post(
        _query_url,
        headers: _headers,
        parameters: body.to_json
      )
      OAuth2.apply(config, _request)
      _response = execute_request(_request)

      # Return appropriate response type.
      decoded = APIHelper.json_deserialize(_response.raw_body)
      _errors = APIHelper.map_response(decoded, ['errors'])
      ApiResponse.new(
        _response, data: decoded, errors: _errors
      )
    end
  end
end
