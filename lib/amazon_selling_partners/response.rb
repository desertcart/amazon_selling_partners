# frozen_string_literal: true

module AmazonSellingPartners
  class Response
    attr_reader :body,
                :headers,
                :raw,
                :request,
                :status

    def initialize(request:, status:, body: nil, headers: {}, raw: nil, convert_to_json: true) # rubocop:disable Metrics/ParameterLists
      @body = convert_to_json ? parse_json(body) : body
      @headers = headers
      @raw = raw
      @request = request
      @status = status
    end

    def failure?
      !success?
    end

    def success?
      (200..299).include?(status)
    end

    def self.new_from_typhoeus_response(typhoeus_response:, request:, convert_to_json: false)
      new(
        body: typhoeus_response.body,
        headers: typhoeus_response.headers,
        raw: typhoeus_response,
        request:,
        status: typhoeus_response.options[:response_code].to_i,
        convert_to_json:
      )
    end

    def self.new_from_faraday_response(faraday_response:, request:)
      new(
        body: faraday_response.body,
        headers: faraday_response.headers,
        raw: faraday_response,
        request:,
        status: faraday_response.status
      )
    end

    def self.new_from_oauth_response(oauth_response:, request:)
      # Uses the same API
      new_from_faraday_response(
        faraday_response: oauth_response,
        request:
      )
    end

    private

    def parse_json(json)
      return if json.nil?

      JSON.parse(json)
    rescue JSON::ParserError
      nil
    end
  end
end
