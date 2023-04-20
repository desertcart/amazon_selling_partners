# frozen_string_literal: true

require_relative '../types/array'

module AmazonSellingPartners
  class OrdersList < AmazonSellingPartners::Resource
    attribute :next_token, type: LedgerSync::Type::String
    attribute :last_updated_after, type: LedgerSync::Type::String
    attribute :marketplace_id, type: LedgerSync::Type::String
    attribute :order_statuses, type: AmazonSellingPartners::Type::Array

    references_many :orders, to: AmazonSellingPartners::Order
  end
end
