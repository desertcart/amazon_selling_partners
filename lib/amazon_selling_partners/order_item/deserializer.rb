# frozen_string_literal: true

require_relative 'item_deserializer'

module AmazonSellingPartners
  class OrderItem
    class Deserializer < LedgerSync::Deserializer
      attribute :next_token, hash_attribute: 'payload.NextToken'
      references_many :order_items,
                      hash_attribute: 'payload.OrderItems',
                      deserializer: AmazonSellingPartners::OrderItem::ItemDeserializer
    end
  end
end
