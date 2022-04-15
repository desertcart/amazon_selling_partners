# frozen_string_literal: true

require_relative 'feed_document'
require_relative 'feed_content'

module AmazonSellingPartners
  class Feed < AmazonSellingPartners::Resource
    # https://developer-docs.amazon.com/sp-api/docs/feed-type-values
    FEED_TYPES = {
      values: %w[
        POST_FLAT_FILE_PRICEANDQUANTITYONLY_UPDATE_DATA
        POST_FLAT_FILE_INVLOADER_DATA
      ]
    }.freeze

    attribute :feed_id, type: LedgerSync::Type::String
    attribute :result_feed_document_id, type: LedgerSync::Type::String
    attribute :market_place_id, type: LedgerSync::Type::String
    attribute :feed_type, type: LedgerSync::Type::StringFromSet.new(FEED_TYPES)
    references_one :feed_document, to: AmazonSellingPartners::FeedDocument
  end
end
