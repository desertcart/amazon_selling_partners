# frozen_string_literal: true

module AmazonSellingPartners
  class OrderItems < AmazonSellingPartners::Resource
    attribute :amazon_order_id, type: LedgerSync::Type::String
    attribute :next_token, type: LedgerSync::Type::String
  end
end
