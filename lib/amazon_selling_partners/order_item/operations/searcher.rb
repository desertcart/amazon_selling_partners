# frozen_string_literal: true

module AmazonSellingPartners
  class OrderItem
    class Operation
      class Searcher < AmazonSellingPartners::Operation::Searcher
        def resources
          @resources ||= begin
           return response.body
                          .dig("payload", "OrderItems")
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
          "/orders/v0/orders/#{query['amazon_order_id']}/orderItems"
        end

        def opts
          {
            body: nil,
            form_params: {},
            query_params: {
              'NextToken' => query['NextToken'],
            }
          }
        end
      end
    end
  end
end
