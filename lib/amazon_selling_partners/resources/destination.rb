# frozen_string_literal: true

module AmazonSellingPartners
  class Destination < AmazonSellingPartners::Resource
    attribute :id, type: LedgerSync::Type::String
  end
end
