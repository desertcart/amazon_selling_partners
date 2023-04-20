# frozen_string_literal: true

require_relative 'shipping_address'
require_relative 'order_total'

module AmazonSellingPartners
  class Order < AmazonSellingPartners::Resource
    attribute :amazon_order_id, type: LedgerSync::Type::String
    attribute :purchase_date, type: LedgerSync::Type::String
    attribute :order_status, type: LedgerSync::Type::String
    attribute :shipped_items_count, type: LedgerSync::Type::Integer
    attribute :unshipped_items_count, type: LedgerSync::Type::Integer
    attribute :order_total_amount, type: LedgerSync::Type::String
    attribute :order_total_currency, type: LedgerSync::Type::String

    references_one :shipping_address, to: AmazonSellingPartners::ShippingAddress
  end
end
