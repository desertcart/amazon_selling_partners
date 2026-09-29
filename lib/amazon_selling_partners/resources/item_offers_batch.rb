# frozen_string_literal: true

require_relative 'product_pricing'
require_relative '../types/array'

module AmazonSellingPartners
  # Offers for up to 20 ASINs in one getItemOffersBatch call.
  #
  # Keyed by ASIN, so it works for items the seller does not list (unlike
  # ProductPricing::Operation::FindBatch, which calls listingOffers and needs
  # our own SKUs). After a successful perform, `items` holds one
  # ProductPricing per requested ASIN with `status_code`, `offers`,
  # `total_offer_count` and, for failed items, `error_code`/`error_message`.
  class ItemOffersBatch < AmazonSellingPartners::Resource
    MAX_ASINS = 20
    DEFAULT_ITEM_CONDITION = 'New'

    attribute :market_place_id, type: LedgerSync::Type::String
    attribute :asins, type: AmazonSellingPartners::Type::Array
    attribute :item_condition, type: LedgerSync::Type::String
    # x-amzn-RateLimit-Limit returned by Amazon for this operation (requests/second)
    attribute :rate_limit, type: LedgerSync::Type::Float
    references_many :items, to: AmazonSellingPartners::ProductPricing
  end
end
