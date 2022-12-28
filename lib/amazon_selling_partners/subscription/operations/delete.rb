# frozen_string_literal: true

module AmazonSellingPartners
  class Subscription
    class Operation
      class Delete < AmazonSellingPartners::Operation::Delete

        private

        def request_method
          :delete
        end
        def url
          "/notifications/v1/subscriptions/#{resource.notification_type}/#{resource.id}"
        end

        def opts
          {
            body: {},
            form_params: {},
            query_params: {}
          }
        end
      end
    end
  end
end
