# frozen_string_literal: true

module AmazonSellingPartners
  module Errors
    class AuthError < StandardError
      attr_reader :code, :response_headers, :response_body

      def initialize(code:, response_headers:, response_body:, message: nil)
        @code = code
        @response_headers = response_headers
        @response_body = response_body
        message = { code:, response_headers:, response_body: }.to_s unless message.present?

        super(message)
      end
    end
  end
end
