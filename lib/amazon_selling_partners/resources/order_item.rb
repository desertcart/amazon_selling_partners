# frozen_string_literal: true

module AmazonSellingPartners
  class OrderItem < AmazonSellingPartners::Resource
    attribute :asin, type: LedgerSync::Type::String
    attribute :seller_sku, type: LedgerSync::Type::String
    attribute :amazon_order_item_id, type: LedgerSync::Type::String
    attribute :title, type: LedgerSync::Type::String
    attribute :quantity_ordered, type: LedgerSync::Type::Integer
    attribute :quantity_shipped, type: LedgerSync::Type::Integer
    attribute :items_count_in_asin, type: LedgerSync::Type::String
    attribute :item_price_amount, type: LedgerSync::Type::String
    attribute :item_price_currency_code, type: LedgerSync::Type::String
  end
end
