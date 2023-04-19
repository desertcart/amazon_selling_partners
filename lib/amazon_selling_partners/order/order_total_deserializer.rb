# frozen_string_literal: true

module AmazonSellingPartners
  class Order
    class OrderTotalDeserializer < LedgerSync::Deserializer
      attribute :currency_code, hash_attribute: 'CurrencyCode'
      attribute :amount, hash_attribute: 'Amount'
    end
  end
end
