# frozen_string_literal: true

module AmazonSellingPartners
  class ProductPricing
    class Operation
      class FindBatch < AmazonSellingPartners::Operation::Create
        def operate
          if response.failure?
            return failure(
              response.body&.[]('errors') || 'AmazonSellingPartners api request failed'
            )
          end

          success(
            resource:,
            response: response.body
          )
        end

        private

        def request_method
          :post
        end

        def url
          '/batches/products/pricing/v0/listingOffers'
        end

        def opts
          {
            body: {
              requests: resource.requests
            },
            header_params: {
              'Content-Type' => 'application/json'
            },
            form_params: {},
            query_params: {}
          }
        end
      end
    end
  end
end
