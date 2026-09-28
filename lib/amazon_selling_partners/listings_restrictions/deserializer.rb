# frozen_string_literal: true

module AmazonSellingPartners
  class ListingsRestrictions
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :restrictions, hash_attribute: 'restrictions'
    end
  end
end
