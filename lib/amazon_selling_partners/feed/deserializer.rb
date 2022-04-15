# frozen_string_literal: true

require_relative '../encryption_detail/deserializer'

module AmazonSellingPartners
  class Feed
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :feed_id, hash_attribute: 'feedId'
      attribute :result_feed_document_id, hash_attribute: 'resultFeedDocumentId'
    end
  end
end
