# frozen_string_literal: true

module AmazonSellingPartners
  module Errors
    # A failed SP-API request, classified so callers can react per cause:
    # suspend an account on Unauthorized, back off on Throttled, retry
    # elsewhere on ServerError.
    class RequestError < StandardError
      attr_reader :status, :response_body, :response_headers

      def initialize(status: nil, response_body: nil, response_headers: {}, message: nil)
        @status = status
        @response_body = response_body
        @response_headers = response_headers || {}

        super(message || "SP-API request failed (status #{status.inspect}): #{response_body}")
      end

      def self.for_status(status)
        case status.to_i
        when 401, 403 then Unauthorized
        when 404 then NotFound
        when 429 then Throttled
        when 500..599 then ServerError
        else RequestError
        end
      end

      # Builds the subclass matching a failed LedgerSync response's status.
      def self.from_response(response)
        for_status(response.status).new(
          status: response.status, response_body: response.body, response_headers: response.headers
        )
      end

      # A failed LWA token refresh, by the token endpoint's answer: rejected
      # credentials are Unauthorized, while no answer (status 0, e.g. a timeout)
      # or a 5xx is a ServerError and 429 is Throttled.
      def self.from_auth_error(error)
        klass = case error.code.to_i
                when 0, 500..599 then ServerError
                when 429 then Throttled
                else Unauthorized
                end
        klass.new(
          status: error.code, response_body: error.response_body, response_headers: error.response_headers,
          message: "LWA token refresh failed: #{error.message}"
        )
      end
    end

    # 401/403 from the API, or the LWA token refresh was rejected
    # (revoked or invalid refresh token).
    class Unauthorized < RequestError; end

    # 404, e.g. a listings item (SKU) the seller doesn't have.
    class NotFound < RequestError; end

    # 429 / QuotaExceeded.
    class Throttled < RequestError; end

    # 5xx, timeouts and connection failures.
    class ServerError < RequestError; end
  end
end
