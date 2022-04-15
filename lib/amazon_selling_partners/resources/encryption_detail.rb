# frozen_string_literal: true

module AmazonSellingPartners
  class EncryptionDetail < AmazonSellingPartners::Resource
    attribute :key, type: LedgerSync::Type::String
    attribute :standard, type: LedgerSync::Type::String
    attribute :initialization_vector, type: LedgerSync::Type::String
  end
end
