# frozen_string_literal: true

require_relative 'feed_content'
require_relative '../types/array'

module AmazonSellingPartners
  class FeedDocument < AmazonSellingPartners::Resource
    attribute :url, type: LedgerSync::Type::String
    attribute :feed_document_id, type: LedgerSync::Type::String
    attribute :content_attributes, type: AmazonSellingPartners::Type::Array
    attribute :seller_id, type: LedgerSync::Type::String
    # Case: POST_FLAT_FILE_PRICEANDQUANTITYONLY_UPDATE_DATA
    # [:sku, :quantity, :price, :maximum_seller_allowed_price, :minimum_seller_allowed_price, :handling_time]
    # Case: POST_FLAT_FILE_INVLOADER_DATA
    # [:sku, :quantity, :price, :maximum_seller_allowed_price, :minimum_seller_allowed_price,
    # :handling_time, :product_id, :product_id_type, :item_condition]
    # Important! skip :quantity if product is FBA, passing quantity will convert it to FBM

    references_many :feed_contents, to: AmazonSellingPartners::FeedContent
  end
end
