# frozen_string_literal: true

require_relative '../pricing_offer/deserializer'

module AmazonSellingPartners
  class Subscription
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :id, hash_attribute: 'payload.subscriptionId'
      references_one :destination, hash_attribute: 'payload'
    end
  end
end
