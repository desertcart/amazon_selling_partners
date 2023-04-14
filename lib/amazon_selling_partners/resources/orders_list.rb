# frozen_string_literal: true

module AmazonSellingPartners
  class OrdersList < AmazonSellingPartners::Resource
    attribute :created_before, type: AmazonSellingPartners::Type::IsoDate
    attribute :order_statuses, type: AmazonSellingPartners::Type::Array
    attribute :marketplace_ids, type: AmazonSellingPartners::Type::Array
  end
end
