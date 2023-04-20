# frozen_string_literal: true

module AmazonSellingPartners
  class Order
    class Operation
      class Searcher < AmazonSellingPartners::Operation::Searcher
        def operate
          return failure(response.status) if response.failure?

          success(
            resource: deserializer.deserialize(
              hash: response.body,
              resource:
            ),
            response: response.body
          )
        end

        private

        def request_method
          :get
        end

        def url
          "/orders/v0/orders"
        end
        def opts
          {
            body: nil,
            form_params: {},
            query_params: {
              'MarketplaceIds' => resource.marketplace_id,
              'LastUpdatedAfter' => resource.last_updated_after,
              'OrderStatuses' => resource.order_statuses.join(','),
              'NextToken' =>  resource.next_token
            }
          }
        end
      end
    end
  end
end
