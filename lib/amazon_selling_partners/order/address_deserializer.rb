# frozen_string_literal: true

module AmazonSellingPartners
  class Order
    class AddressDeserializer < LedgerSync::Deserializer
      attribute :name, hash_attribute: 'Name'
      attribute :address_line_1, hash_attribute: 'AddressLine1'
      attribute :address_line_2, hash_attribute: 'AddressLine2'
      attribute :address_line_3, hash_attribute: 'AddressLine3'
      attribute :city, hash_attribute: 'City'
      attribute :county, hash_attribute: 'County'
      attribute :district, hash_attribute: 'District'
      attribute :state_or_region, hash_attribute: 'StateOrRegion'
      attribute :municipality, hash_attribute: 'Municipality'
      attribute :postal_code, hash_attribute: 'PostalCode'
      attribute :country_code, hash_attribute: 'CountryCode'
      attribute :phone, hash_attribute: 'Phone'
      attribute :address_type, hash_attribute: 'AddressType'
    end
  end
end
