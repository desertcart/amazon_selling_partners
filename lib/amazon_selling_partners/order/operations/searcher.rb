# frozen_string_literal: true

module AmazonSellingPartners
  class Order
    class Operation
      class Searcher < AmazonSellingPartners::Operation::Searcher
        def resources
          @resources ||= begin
            return response.body
                   .dig("payload", "Orders")
                   .map { |o| deserialized_resource(hash: o) } if response.status == 200

           []
          end
        end

        def next_token
          return response.body.dig('payload', 'NextToken') if response.status == 200

          nil
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
              'LastUpdatedAfter' => query['LastUpdatedAfter'],
              'NextToken' => query['NextToken'],
              'MarketplaceIds' => query['MarketplaceIds'],
              'OrderStatuses' => query['OrderStatuses'],
            }
          }
        end
      end
    end
  end
end
