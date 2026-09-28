# frozen_string_literal: true

module AmazonSellingPartners
  class ItemOffersBatch
    class Operation
      class Find < AmazonSellingPartners::Operation::Create
        ASIN_FROM_URI = %r{/items/([^/?]+)/offers}

        def operate
          # Validate before the HTTP call; only then look at the response.
          error = invalid_asins_error || response_error
          return failure(error) if error

          assign_results
          success(resource:, response: response.body)
        rescue Errors::AuthError => e
          failure(Errors::Unauthorized.from_auth_error(e))
        rescue Faraday::Error => e
          failure(Errors::ServerError.new(message: e.message))
        end

        private

        def request_method
          :post
        end

        def url
          '/batches/products/pricing/v0/itemOffers'
        end

        def opts
          {
            body: { requests: },
            header_params: { 'Content-Type' => 'application/json' },
            form_params: {},
            query_params: {}
          }
        end

        def requests
          asins.map do |asin|
            {
              uri: "/products/pricing/v0/items/#{asin}/offers",
              method: 'GET',
              MarketplaceId: resource.market_place_id,
              ItemCondition: item_condition
            }
          end
        end

        def asins
          @asins ||= Array(resource.asins).map(&:to_s).reject(&:empty?)
        end

        def item_condition
          resource.item_condition.presence || AmazonSellingPartners::ItemOffersBatch::DEFAULT_ITEM_CONDITION
        end

        def invalid_asins_error
          return if asins.size.between?(1, AmazonSellingPartners::ItemOffersBatch::MAX_ASINS)

          Errors::RequestError.new(
            message: "getItemOffersBatch takes 1..#{AmazonSellingPartners::ItemOffersBatch::MAX_ASINS} ASINs, " \
                     "got #{asins.size}"
          )
        end

        def response_error
          Errors::RequestError.from_response(response) if response.failure?
        end

        def assign_results
          resource.rate_limit = rate_limit
          responses = Array(response.body&.[]('responses'))
          resource.items = responses.each_with_index.map { |item, index| build_item(item, index) }
        end

        def rate_limit
          value = response.headers&.[]('x-amzn-RateLimit-Limit')
          value.present? ? value.to_f : nil
        end

        def build_item(item, index)
          body = item['body'].is_a?(Hash) ? item['body'] : {}
          pricing = AmazonSellingPartners::ProductPricing::Deserializer.new.deserialize(
            hash: with_offers_array(body),
            resource: AmazonSellingPartners::ProductPricing.new(market_place_id: resource.market_place_id)
          )
          pricing.asin = asin_for(item, body, index)
          pricing.status_code = item.dig('status', 'statusCode')
          assign_error(pricing, body)
          pricing
        end

        # Failed items carry no payload, and references_many rejects nil.
        def with_offers_array(body)
          payload = body['payload'].is_a?(Hash) ? body['payload'] : {}
          body.merge('payload' => payload.merge('Offers' => Array(payload['Offers'])))
        end

        # payload.ASIN is absent on failed items; fall back to the echoed request,
        # then to request order (Amazon answers in the order requested).
        def asin_for(item, body, index)
          body.dig('payload', 'ASIN').presence ||
            item.dig('request', 'Asin').presence ||
            item.dig('request', 'uri').to_s[ASIN_FROM_URI, 1].presence ||
            asins[index]
        end

        def assign_error(pricing, body)
          error = Array(body['errors']).first
          return unless error.is_a?(Hash)

          pricing.error_code = error['code']
          pricing.error_message = error['message']
        end
      end
    end
  end
end
