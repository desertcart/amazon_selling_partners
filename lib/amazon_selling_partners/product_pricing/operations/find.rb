# frozen_string_literal: true

module AmazonSellingPartners
  class ProductPricing
    class Operation
      class Find < AmazonSellingPartners::Operation::Find
        private

        def request_method
          :get
        end

        def url
          "/products/pricing/v0/items/#{resource.asin}/offers" \
            "?MarketplaceId=#{resource.market_place_id}&ItemCondition=New"
        end

        def opts
          {
            body: nil,
            header_params: {
              'Content-Type' => 'application/json'
            },
            form_params:,
            query_params:
          }
        end

        def query_params
          {}
        end

        def form_params
          {}
        end
      end
    end
  end
end
