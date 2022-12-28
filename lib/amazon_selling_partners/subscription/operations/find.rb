# frozen_string_literal: true

module AmazonSellingPartners
  class Subscription
    class Operation
      class Find < AmazonSellingPartners::Operation::Find

        private
        def request_method
          :get
        end
        def url
          "/notifications/v1/subscriptions/#{resource.notification_type}"
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
