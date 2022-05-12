# frozen_string_literal: true

require_relative 'feed_document'
require_relative 'feed_content'

module AmazonSellingPartners
  class ProductPricing < AmazonSellingPartners::Resource
    attribute :market_place_id, type: LedgerSync::Type::String
    attribute :asin, type: LedgerSync::Type::String
    references_many :offers, to: AmazonSellingPartners::PricingOffer
  end
end
