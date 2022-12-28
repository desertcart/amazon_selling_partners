# frozen_string_literal: true

module AmazonSellingPartners
  class Subscription < AmazonSellingPartners::Resource
    # notification types --> https://developer-docs.amazon.com/sp-api/docs/notifications-api-v1-use-case-guide#tutorial-set-up-notifications-amazon-simple-queue-service-workflow
    NOTIFICATION_TYPES = {
      values: %w[
        ANY_OFFER_CHANGED
      ]
    }.freeze

    attribute :id, type: LedgerSync::Type::String
    attribute :notification_type, type: LedgerSync::Type::StringFromSet.new(NOTIFICATION_TYPES)
    references_one :destination, to: AmazonSellingPartners::Destination
  end
end
