# frozen_string_literal: true

module AmazonSellingPartners
  module Errors
    class UnsupportedCountryCodeError < StandardError
      attr_reader :code, :response_headers, :response_body

      def initialize(country_code:, supported_country_codes:, message: nil)
        unless message.present?
          message = "'#{country_code}' is not a supported country code."
          message += " List of supported country codes: #{supported_country_codes.join(', ')}."
        end

        super(message)
      end
    end
  end
end
