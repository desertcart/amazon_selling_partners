# frozen_string_literal: true

module AmazonSellingPartners
  class OrdersList < AmazonSellingPartners::Resource
    attribute :next_token, type: LedgerSync::Type::String
    references_many :orders, to: AmazonSellingPartners::Order
  end
end
