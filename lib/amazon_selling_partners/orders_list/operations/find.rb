# frozen_string_literal: true

module AmazonSellingPartners
  class OrdersList
    class Operation
      class Find < AmazonSellingPartners::Operation::Find

        def initialize(args = {})
          @query_params = args.fetch(:query_params)
          super
        end

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
        # ?LastUpdatedAfter=#{resource.last_updated_after}&OrderStatuses=#{resource.order_statuses}&MarketplaceIds=#{resource.marketplace_ids}&NextToken=#{resource.next_token}
        def opts
          {
            body: nil,
            form_params: {},
            query_params: @query_params
          }
        end
      end
    end
  end
end
