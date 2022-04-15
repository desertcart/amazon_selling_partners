# frozen_string_literal: true

require_relative '../types/array'

module AmazonSellingPartners
  class FeedResult < AmazonSellingPartners::Resource
    attribute :url, type: LedgerSync::Type::String
    attribute :processed, type: LedgerSync::Type::Integer
    attribute :successful, type: LedgerSync::Type::Integer
    attribute :ledger_errors, type: AmazonSellingPartners::Type::Array
  end
end
