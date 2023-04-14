# frozen_string_literal: true

module AmazonSellingPartners
  class Orders
    class Operation
      class Find < AmazonSellingPartners::Operation::Find
        private

        def request_method
          :get
        end

        def url
          "/orders/v0/orders?CreatedBefore=#{resource.created_before}&OrderStatuses=#{resource.order_statuses}&MarketplaceIds=#{resource.marketplace_ids}"
        end

        def opts
          {
            body: nil,
            form_params: {},
            query_params: {}
          }
        end
      end
    end
  end
end
