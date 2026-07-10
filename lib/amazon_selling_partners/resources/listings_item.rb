# frozen_string_literal: true

require_relative '../types/array'

module AmazonSellingPartners
  class ListingsItem < AmazonSellingPartners::Resource
    attribute :seller_id, type: LedgerSync::Type::String
    attribute :sku, type: LedgerSync::Type::String
    attribute :marketplace_id, type: LedgerSync::Type::String
    attribute :product_type, type: LedgerSync::Type::String
    attribute :patches, type: AmazonSellingPartners::Type::Array

    # Response fields
    attribute :status, type: LedgerSync::Type::String
    attribute :submission_id, type: LedgerSync::Type::String
  end
end
