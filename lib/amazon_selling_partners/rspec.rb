# frozen_string_literal: true

module AmazonSellingPartners
  module Rspec
    # rubocop:disable Metrics/ParameterLists, Metrics/MethodLength
    def selling_partner_product_pricing_stub(
      client_id:, client_secret:, marketplace_id:,
      refresh_token:, asin:, response:
    )
      # rubocop:enable Metrics/ParameterLists, Metrics/MethodLength
      stub_request(:post, 'https://api.amazon.com/auth/o2/token')
        .with(
          body: { 'client_id' => client_id, 'client_secret' => client_secret, 'grant_type' => 'refresh_token',
                  'refresh_token' => refresh_token },
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/x-www-form-urlencoded',
            'Expect' => '',
            'User-Agent' => 'Swagger-Codegen/0.0.1/ruby'
          }
        )
        .to_return(status: 200, body: { access_token: 'token', expires_in: 1.hour.from_now.to_i }.to_json, headers: {})

      stub_request(:get, "https://sellingpartnerapi-eu.amazon.com/products/pricing/v0/items/#{asin}/offers?ItemCondition=New&MarketplaceId=#{marketplace_id}")
        .to_return(status: 200, body: response.to_json, headers: {})
    end
  end
end
