# frozen_string_literal: true

module AmazonSellingPartners
  class Orders
    class Deserializer < LedgerSync::Deserializer
      attribute :next_token, hash_attribute: 'payload.NextToken'
      references_many :orders, hash_attribute: 'payload.Orders', deserializer: AmazonSellingPartners::Order::Deserializer
    end
  end
end
