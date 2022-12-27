# frozen_string_literal: true

require 'net/http'
require 'uri'

module AmazonSellingPartners
  class Subscription
    class Operation
      class Create < AmazonSellingPartners::Operation::Create

        private

        def request_method
          :post
        end
        def url
          "/notifications/v1/subscriptions/#{resource.notification_type}"
        end

        def opts
          {
            body: {
              payloadVersion: "1.0",
              destinationId: resource.destination.id
            },
            form_params: {},
            query_params: {}
          }
        end
      end
    end
  end
end
