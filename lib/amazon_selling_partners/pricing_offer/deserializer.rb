# frozen_string_literal: true

require_relative '../encryption_detail/deserializer'

module AmazonSellingPartners
  class PricingOffer
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :seller_id, hash_attribute: 'SellerId'
      attribute :price, hash_attribute: 'ListingPrice.Amount'
      attribute :shipping_cost, hash_attribute: 'Shipping.Amount'
      attribute :shipping_country, hash_attribute: 'ShipsFrom.Country'
      attribute :condition, hash_attribute: 'SubCondition'
      attribute :is_buybox_winner, hash_attribute: 'IsBuyBoxWinner'
    end
  end
end
