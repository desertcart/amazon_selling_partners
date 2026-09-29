# frozen_string_literal: true

require_relative '../types/array'

module AmazonSellingPartners
  # Whether a seller may list an ASIN in a condition on a marketplace.
  # restrictions is empty when nothing stands in the way; otherwise each entry
  # carries reasons with a reasonCode (APPROVAL_REQUIRED, ASIN_NOT_FOUND,
  # NOT_ELIGIBLE) and a message.
  class ListingsRestrictions < AmazonSellingPartners::Resource
    DEFAULT_CONDITION_TYPE = 'new_new'

    attribute :asin, type: LedgerSync::Type::String
    attribute :seller_id, type: LedgerSync::Type::String
    attribute :marketplace_id, type: LedgerSync::Type::String
    attribute :condition_type, type: LedgerSync::Type::String

    # Response fields
    attribute :restrictions, type: AmazonSellingPartners::Type::Array
  end
end
