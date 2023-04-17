# frozen_string_literal: true

module AmazonSellingPartners
  class OrderItem
    class Deserializer < LedgerSync::Deserializer
      attribute :asin, hash_attribute: 'ASIN'
      attribute :seller_sku, hash_attribute: 'SellerSKU'
      attribute :amazon_order_item_id, hash_attribute: 'OrderItemId'
      attribute :title, hash_attribute: 'Title'
      attribute :quantity_ordered, hash_attribute: 'QuantityOrdered'
      attribute :quantity_shipped, hash_attribute: 'QuantityShipped'
      attribute :items_count_in_asin, hash_attribute: 'ProductInfo.NumberOfItems'
      attribute :item_price_amount, hash_attribute: 'ItemPrice.Amount'
      attribute :item_price_currency_code, hash_attribute: 'ItemPrice.CurrencyCode'
    end
  end
end
