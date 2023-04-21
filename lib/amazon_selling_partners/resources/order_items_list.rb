# frozen_string_literal: true

require_relative 'order_item'

module AmazonSellingPartners
  class OrderItemsList < AmazonSellingPartners::Resource
    attribute :amazon_order_id, type: LedgerSync::Type::String
    attribute :next_token, type: LedgerSync::Type::String
    references_many :order_items, to: AmazonSellingPartners::OrderItem
  end
end
