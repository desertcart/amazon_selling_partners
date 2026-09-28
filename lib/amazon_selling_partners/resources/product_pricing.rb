# frozen_string_literal: true

require_relative 'pricing_offer'
require_relative '../types/array'

module AmazonSellingPartners
  class ProductPricing < AmazonSellingPartners::Resource
    attribute :market_place_id, type: LedgerSync::Type::String
    attribute :asin, type: LedgerSync::Type::String
    attribute :requests, type: AmazonSellingPartners::Type::Array
    attribute :total_offer_count, type: LedgerSync::Type::Integer
    # Set per item by ItemOffersBatch::Operation::Find
    attribute :status_code, type: LedgerSync::Type::Integer
    attribute :error_code, type: LedgerSync::Type::String
    attribute :error_message, type: LedgerSync::Type::String
    references_many :offers, to: AmazonSellingPartners::PricingOffer
  end
end
