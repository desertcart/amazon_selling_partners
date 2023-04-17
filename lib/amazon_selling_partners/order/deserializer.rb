# frozen_string_literal: true

module AmazonSellingPartners
  class Order
    class Deserializer < LedgerSync::Deserializer
      attribute :amazon_order_id, hash_attribute: 'AmazonOrderId'
      attribute :purchase_date, hash_attribute: 'PurchaseDate'
      attribute :order_status, hash_attribute: 'OrderStatus'
      attribute :order_total, hash_attribute: 'OrderTotal'
      attribute :shipped_items_count, hash_attribute: 'NumberOfItemsShipped'
      attribute :unshipped_items_count, hash_attribute: 'NumberOfItemsUnshipped'
      references_one :shipping_address, hash_attribute: 'ShippingAddress', deserializer: AmazonSellingPartners::Order::AddressDeserializer
    end
  end
end
