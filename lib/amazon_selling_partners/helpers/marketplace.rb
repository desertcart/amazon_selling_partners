# frozen_string_literal: true

module AmazonSellingPartners
  module Helpers
    class Marketplace
      # https://developer-docs.amazon.com/sp-api/docs/marketplace-ids
      MARKETPLACES = {
        # North America
        'CA' => {
          marketplace_id: 'A2EUQ1WTGCTBG2',
          region: 'na'
        },
        'US' => {
          marketplace_id: 'ATVPDKIKX0DER',
          region: 'na'
        },
        'MX' => {
          marketplace_id: 'A1AM78C64UM0Y8',
          region: 'na'
        },
        'BR' => {
          marketplace_id: 'A2Q3Y263D00KWC',
          region: 'na'
        },

        # Europe
        'ES' =>	{
          marketplace_id: 'A1RKKUPIHCS9HS',
          region: 'eu'
        },
        'UK' =>	{
          marketplace_id: 'A1F83G8C2ARO7P',
          region: 'eu'
        },
        'FR' =>	{
          marketplace_id: 'A13V1IB3VIYZZH',
          region: 'eu'
        },
        'BE' =>	{
          marketplace_id: 'AMEN7PMS3EDWL',
          region: 'eu'
        },
        'NL' =>	{
          marketplace_id: 'A1805IZSGTT6HS',
          region: 'eu'
        },
        'DE' =>	{
          marketplace_id: 'A1PA6795UKMFR9',
          region: 'eu'
        },
        'IT' =>	{
          marketplace_id: 'APJ6JRA9NG5V4',
          region: 'eu'
        },
        'SE' =>	{
          marketplace_id: 'A2NODRKZP88ZB9',
          region: 'eu'
        },
        'PL' =>	{
          marketplace_id: 'A1C3SOZRARQ6R3',
          region: 'eu'
        },
        'EG' =>	{
          marketplace_id: 'ARBP9OOSHTCHU',
          region: 'eu'
        },
        'TR' =>	{
          marketplace_id: 'A33AVAJ2PDY3EV',
          region: 'eu'
        },
        'SA' =>	{
          marketplace_id: 'A17E79C6D8DWNP',
          region: 'eu'
        },
        'AE' =>	{
          marketplace_id: 'A2VIGQ35RCS4UG',
          region: 'eu'
        },
        'IN' =>	{
          marketplace_id: 'A21TJRUUN4KGV',
          region: 'eu'
        },

        # Far East
        'SG' => {
          marketplace_id: 'A19VAU5U5O7RUS',
          region: 'fa'
        },
        'AU' => {
          marketplace_id: 'A39IBJ37TRP1C6',
          region: 'fa'
        },
        'JP' => {
          marketplace_id: 'A1VC38T7YXB528',
          region: 'fa'
        }
      }.freeze

      attr_reader :id, :region

      def initialize(country_code:)
        raise StandardError "#{country_code} is not supported" unless MARKETPLACES.keys.include?(country_code)

        @id = MARKETPLACES[country_code][:marketplace_id]
        @region = MARKETPLACES[country_code][:region]
      end
    end
  end
end
