# frozen_string_literal: true

require_relative './order_total_deserializer'
require_relative './address_deserializer'

module AmazonSellingPartners
  class Order
    class Deserializer < LedgerSync::Deserializer
      attribute :amazon_order_id, hash_attribute: 'AmazonOrderId'
      attribute :purchase_date, hash_attribute: 'PurchaseDate'
      attribute :order_status, hash_attribute: 'OrderStatus'
      attribute :shipped_items_count, hash_attribute: 'NumberOfItemsShipped'
      attribute :unshipped_items_count, hash_attribute: 'NumberOfItemsUnshipped'
      references_one :shipping_address,
                     hash_attribute: 'ShippingAddress',
                     deserializer: AmazonSellingPartners::Order::AddressDeserializer
      references_one :order_total,
                     hash_attribute: 'OrderTotal',
                     deserializer: AmazonSellingPartners::Order::OrderTotalDeserializer
    end
  end
end
