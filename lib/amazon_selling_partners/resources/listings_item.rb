# frozen_string_literal: true

require_relative '../types/array'

module AmazonSellingPartners
  class ListingsItem < AmazonSellingPartners::Resource
    VALIDATION_PREVIEW = 'VALIDATION_PREVIEW'

    attribute :seller_id, type: LedgerSync::Type::String
    attribute :sku, type: LedgerSync::Type::String
    attribute :marketplace_id, type: LedgerSync::Type::String
    attribute :product_type, type: LedgerSync::Type::String
    attribute :patches, type: AmazonSellingPartners::Type::Array
    # putListingsItem: e.g. LISTING_OFFER_ONLY, and the listing's attributes
    attribute :requirements, type: LedgerSync::Type::String
    attribute :listing_attributes, type: LedgerSync::Type::Hash
    # VALIDATION_PREVIEW validates a submission without saving it
    attribute :mode, type: LedgerSync::Type::String

    # Response fields
    attribute :status, type: LedgerSync::Type::String
    attribute :submission_id, type: LedgerSync::Type::String
    attribute :issues, type: AmazonSellingPartners::Type::Array
    attribute :summaries, type: AmazonSellingPartners::Type::Array
  end
end
