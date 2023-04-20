# frozen_string_literal: true

require_relative './order_total_deserializer'
require_relative './address_deserializer'
require_relative './order_deserializer'

module AmazonSellingPartners
  class Order
    class Deserializer < LedgerSync::Deserializer
      attribute :next_token, hash_attribute: 'payload.NextToken', default: nil
      references_many :orders,
                      hash_attribute: 'payload.Orders',
                      deserializer: AmazonSellingPartners::Order::OrderDeserializer
    end
  end
end
