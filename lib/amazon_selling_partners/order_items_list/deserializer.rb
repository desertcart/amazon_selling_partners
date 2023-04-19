# frozen_string_literal: true

module AmazonSellingPartners
  class OrderItemsList
    class Deserializer < LedgerSync::Deserializer
      attribute :next_token, hash_attribute: 'payload.NextToken'
      references_many :order_items,
                      hash_attribute: 'payload.OrderItems',
                      deserializer: AmazonSellingPartners::OrderItem::Deserializer
    end
  end
end
