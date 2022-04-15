# frozen_string_literal: true

require_relative '../encryption_detail/deserializer'

module AmazonSellingPartners
  class FeedDocument
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :url
      attribute :feed_document_id, hash_attribute: 'feedDocumentId'
    end
  end
end
