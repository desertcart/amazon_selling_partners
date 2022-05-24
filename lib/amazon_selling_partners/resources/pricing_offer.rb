# frozen_string_literal: true

module AmazonSellingPartners
  class PricingOffer < AmazonSellingPartners::Resource
    attribute :seller_id, type: LedgerSync::Type::String
    attribute :price, type: LedgerSync::Type::Float
    attribute :currency, type:LedgerSync::Type::String
    attribute :shipping_cost, type: LedgerSync::Type::Float
    attribute :shipping_country, type: LedgerSync::Type::String
    attribute :condition, type: LedgerSync::Type::String
    attribute :buybox_winner, type: LedgerSync::Type::Boolean
  end
end
