# frozen_string_literal: true

require_relative '../encryption_detail/deserializer'

module AmazonSellingPartners
  class PricingOffer
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :seller_id, hash_attribute: 'SellerId'
      attribute :price, hash_attribute: 'ListingPrice.Amount'
      attribute :currency, hash_attribute: 'ListingPrice.CurrencyCode'
      attribute :shipping_cost, hash_attribute: 'Shipping.Amount'
      attribute :shipping_country, hash_attribute: 'ShipsFrom.Country'
      attribute :condition, hash_attribute: 'SubCondition'
      attribute :buybox_winner, hash_attribute: 'IsBuyBoxWinner'
      # NOTE: SQS AnyOfferChanged offers carry PrimeInformation.IsOfferPrime,
      # ProductPricing API offers carry PrimeInformation.IsPrime
      attribute :is_prime do |res|
        value = res.dig(:hash, 'PrimeInformation', 'IsOfferPrime')
        value.nil? ? res.dig(:hash, 'PrimeInformation', 'IsPrime') : value
      end
      attribute :is_fulfilled_by_amazon, hash_attribute: 'IsFulfilledByAmazon'
    end
  end
end
