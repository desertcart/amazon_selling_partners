# frozen_string_literal: true

module AmazonSellingPartners
  class Destination
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :id, hash_attribute: 'payload.destinationId'
    end
  end
end
