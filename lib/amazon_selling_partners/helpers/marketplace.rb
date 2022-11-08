# frozen_string_literal: true

require_relative '../errors/unsupported_country_code_error'

module AmazonSellingPartners
  module Helpers
    class Marketplace # rubocop:disable Metrics/ClassLength
      # https://developer-docs.amazon.com/sp-api/docs/marketplace-ids
      MARKETPLACES = {
        # North America
        'CA' => {
          marketplace_id: 'A2EUQ1WTGCTBG2',
          region: 'na',
          seller_central_url: 'https://sellercentral.amazon.ca'
        },
        'US' => {
          marketplace_id: 'ATVPDKIKX0DER',
          region: 'na',
          seller_central_url: 'https://sellercentral.amazon.com'
        },
        'MX' => {
          marketplace_id: 'A1AM78C64UM0Y8',
          region: 'na',
          seller_central_url: 'https://sellercentral.amazon.com.mx'
        },
        'BR' => {
          marketplace_id: 'A2Q3Y263D00KWC',
          region: 'na',
          seller_central_url: 'https://sellercentral.amazon.com.br'
        },

        # Europe
        'ES' =>	{
          marketplace_id: 'A1RKKUPIHCS9HS',
          region: 'eu',
          seller_central_url: 'https://sellercentral-europe.amazon.com'
        },
        'UK' =>	{
          marketplace_id: 'A1F83G8C2ARO7P',
          region: 'eu',
          seller_central_url: 'https://sellercentral-europe.amazon.com'
        },
        'FR' =>	{
          marketplace_id: 'A13V1IB3VIYZZH',
          region: 'eu',
          seller_central_url: 'https://sellercentral-europe.amazon.com'
        },
        'BE' =>	{
          marketplace_id: 'AMEN7PMS3EDWL',
          region: 'eu',
          seller_central_url: 'https://sellercentral-europe.amazon.com.be'
        },
        'NL' =>	{
          marketplace_id: 'A1805IZSGTT6HS',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.nl'
        },
        'DE' =>	{
          marketplace_id: 'A1PA6795UKMFR9',
          region: 'eu',
          seller_central_url: 'https://sellercentral-europe.amazon.com'
        },
        'IT' =>	{
          marketplace_id: 'APJ6JRA9NG5V4',
          region: 'eu',
          seller_central_url: 'https://sellercentral-europe.amazon.com'
        },
        'SE' =>	{
          marketplace_id: 'A2NODRKZP88ZB9',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.se'
        },
        'PL' =>	{
          marketplace_id: 'A1C3SOZRARQ6R3',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.pl'
        },
        'EG' =>	{
          marketplace_id: 'ARBP9OOSHTCHU',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.eg'
        },
        'TR' =>	{
          marketplace_id: 'A33AVAJ2PDY3EV',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.com.tr'
        },
        'SA' =>	{
          marketplace_id: 'A17E79C6D8DWNP',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.sa'
        },
        'AE' =>	{
          marketplace_id: 'A2VIGQ35RCS4UG',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.ae'
        },
        'IN' =>	{
          marketplace_id: 'A21TJRUUN4KGV',
          region: 'eu',
          seller_central_url: 'https://sellercentral.amazon.in'
        },

        # Far East
        'SG' => {
          marketplace_id: 'A19VAU5U5O7RUS',
          region: 'fa',
          seller_central_url: 'https://sellercentral.amazon.sg'
        },
        'AU' => {
          marketplace_id: 'A39IBJ37TRP1C6',
          region: 'fa',
          seller_central_url: 'https://sellercentral.amazon.com.au'
        },
        'JP' => {
          marketplace_id: 'A1VC38T7YXB528',
          region: 'fa',
          seller_central_url: 'https://sellercentral.amazon.co.jp'
        }
      }.freeze

      attr_reader :id, :region, :seller_central_url

      def initialize(country_code:)
        unless MARKETPLACES.keys.include?(country_code)
          raise AmazonSellingPartners::Errors::UnsupportedCountryCodeError.new(
            country_code:,
            supported_country_codes: MARKETPLACES.keys
          )
        end

        @id = MARKETPLACES[country_code][:marketplace_id]
        @region = MARKETPLACES[country_code][:region]
        @seller_central_url = MARKETPLACES[country_code][:seller_central_url]
      end
    end
  end
end
