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
          resource.feed_contents.map do |feed_content|
            {
              messageId: feed_content.ref_id,
              sku: feed_content.sku.to_s,
              operationType: 'PARTIAL_UPDATE',
              productType: 'PRODUCT',
              attributes: message_attributes(feed_content)
            }
          end
        end

        def message_attributes(feed_content)
          {
            fulfillment_availability: [
              {
                fulfillment_channel_code: 'DEFAULT',
                quantity: feed_content.quantity,
                lead_time_to_ship_max_days: feed_content.handling_time
              }.compact
            ]
          }.tap do |attrs|
            purchasable_offer = build_purchasable_offer(feed_content)

            attrs[:purchasable_offer] = [purchasable_offer] if purchasable_offer.present?
          end
        end

        def build_purchasable_offer(feed_content)
          purchasable_offer = {}

          if feed_content.price.present?
            purchasable_offer[:our_price] =
              [{ schedule: [{ value_with_tax: feed_content.price }] }]
          end
          if feed_content.maximum_seller_allowed_price.present?
            purchasable_offer[:maximum_seller_allowed_price] =
              [{ schedule: [{ value_with_tax: feed_content.maximum_seller_allowed_price }] }]
          end
          if feed_content.minimum_seller_allowed_price.present?
            purchasable_offer[:minimum_seller_allowed_price] =
              [{ schedule: [{ value_with_tax: feed_content.minimum_seller_allowed_price }] }]
          end

          purchasable_offer
        end
      end
    end
  end
end
