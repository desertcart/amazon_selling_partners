# frozen_string_literal: true

module AmazonSellingPartners
  class ShippingAddress < AmazonSellingPartners::Resource
    attribute :name, type: LedgerSync::Type::String
    attribute :address_line_1, type: LedgerSync::Type::String
    attribute :address_line_2, type: LedgerSync::Type::String
    attribute :address_line_3, type: LedgerSync::Type::String
    attribute :city, type: LedgerSync::Type::String
    attribute :county, type: LedgerSync::Type::String
    attribute :district, type: LedgerSync::Type::String
    attribute :state_or_region, type: LedgerSync::Type::String
    attribute :municipality, type: LedgerSync::Type::String
    attribute :postal_code, type: LedgerSync::Type::String
    attribute :country_code, type: LedgerSync::Type::String
    attribute :phone, type: LedgerSync::Type::String
    attribute :address_type, type: LedgerSync::Type::String
  end
end
