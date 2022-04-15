# frozen_string_literal: true

module AmazonSellingPartners
  class FeedContent < AmazonSellingPartners::Resource
    # Common attributes
    attribute :sku, type: LedgerSync::Type::Integer
    attribute :price, type: LedgerSync::Type::String
    attribute :quantity, type: LedgerSync::Type::Integer
    attribute :minimum_seller_allowed_price, type: LedgerSync::Type::String
    attribute :maximum_seller_allowed_price, type: LedgerSync::Type::String
    attribute :handling_time, type: LedgerSync::Type::Integer

    # POST_FLAT_FILE_INVLOADER_DATA specific attributes
    attribute :product_id, type: LedgerSync::Type::String # ASIN, UPC or EAN, eg: B08N5Q115H
    attribute :product_id_type, type: LedgerSync::Type::Integer
    # 1 = ASIN
    # 2 = ISBN
    # 3 = UPC
    # 4 = EAN
    attribute :item_condition, type: LedgerSync::Type::Integer
    # 1 - Used, Like New
    # 2 - Used, Very Good
    # 3 - Used, Good
    # 4 - Used Acceptable
    # 5 - Collectible, Like New
    # 6 - Collectible, Very Good
    # 7 - Collectible, Good
    # 8 - Collectible, Acceptable
    # 9 - Not used
    # 11 - New
  end
end
