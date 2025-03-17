# frozen_string_literal: true

require 'net/http'
require 'uri'

module AmazonSellingPartners
  class FeedDocument
    class Operation
      class UpdateJson < AmazonSellingPartners::Operation::Update
        def operate
          return failure("AmazonSellingPartners api request failed: #{response.status} #{response.message}") if response.failure?

          success(
            resource: nil,
            response: response.body
          )
        end

        private

        def response # rubocop:disable Metrics/MethodLength
          @response ||= begin
                          request = Typhoeus::Request.new(
                            resource.url,
                            method: :put,
                            headers: { 'content-type' => 'application/json' },
                            body: build_body
                          )
                          request.run

                          AmazonSellingPartners::Response.new_from_typhoeus_response(
                            typhoeus_response: request.response,
                            request:
                          )
                        end
        end

        def build_body
          {
            header: {
              sellerId: resource.seller_id,
              version: '2.0'
            },
            messages: messages
          }.to_json
        end

        def messages
          resource.feed_contents.map.with_index do |feed_content, i|
            {
              messageId: i + 1,
              sku: feed_content.sku.to_s,
              operationType: 'PARTIAL_UPDATE',
              productType: 'PRODUCT',
              attributes: {
                fulfillment_availability: [
                  {
                    fulfillment_channel_code: 'DEFAULT',
                    quantity: feed_content.quantity,
                    lead_time_to_ship_max_days: feed_content.handling_time
                  }
                ],
                purchasable_offer: [
                  {
                    our_price: [
                      { schedule: [{ value_with_tax: feed_content.price }] }
                    ],
                    maximum_seller_allowed_price: [
                      { schedule: [{ value_with_tax: feed_content.maximum_seller_allowed_price }] }
                    ],
                    minimum_seller_allowed_price: [
                      { schedule: [{ value_with_tax: feed_content.minimum_seller_allowed_price }] }
                    ]
                  }
                ]
              }
            }
          end
        end
      end
    end
  end
end
