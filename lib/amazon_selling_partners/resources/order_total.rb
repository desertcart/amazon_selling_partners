# frozen_string_literal: true

module AmazonSellingPartners
  class OrderTotal < AmazonSellingPartners::Resource
    attribute :currency_code, type: LedgerSync::Type::String
    attribute :amount, type: LedgerSync::Type::String
  end
end