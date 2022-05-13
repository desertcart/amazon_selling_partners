# frozen_string_literal: true

require_relative '../encryption_detail/deserializer'

module AmazonSellingPartners
  class ProductPricing
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :asin, hash_attribute: 'payload.ASIN'
      references_many :offers, hash_attribute: 'payload.Offers',
                               deserializer: AmazonSellingPartners::PricingOffer::Deserializer
    end
  end
end
