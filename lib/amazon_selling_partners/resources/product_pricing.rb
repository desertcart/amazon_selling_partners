# frozen_string_literal: true

require_relative 'pricing_offer'
require_relative '../types/array'

module AmazonSellingPartners
  class ProductPricing < AmazonSellingPartners::Resource
    attribute :market_place_id, type: LedgerSync::Type::String
    attribute :asin, type: LedgerSync::Type::String
    attribute :requests, type: AmazonSellingPartners::Type::Array
    references_many :offers, to: AmazonSellingPartners::PricingOffer
  end
end
