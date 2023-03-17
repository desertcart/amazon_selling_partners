# frozen_string_literal: true

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

        def opts # rubocop:disable Metrics/MethodLength
          body = {
            payloadVersion: '1.0',
            destinationId: resource.destination.id
          }

          if resource.notification_type == 'ANY_OFFER_CHANGED'
            body[:processingDirective] = {
              eventFilter: {
                eventFilterType: 'ANY_OFFER_CHANGED',
                marketplaceIds: resource.marketplace_ids
              }
            }
          end

          {
            body:,
            form_params: {},
            query_params: {}
          }
        end
      end
    end
  end
end
