# frozen_string_literal: true

require_relative '../pricing_offer/deserializer'

module AmazonSellingPartners
  class Destination
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :id, hash_attribute: 'destinationId'
    end
  end
end
