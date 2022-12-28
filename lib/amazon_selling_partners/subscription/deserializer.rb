# frozen_string_literal: true

module AmazonSellingPartners
  class Subscription
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :id, hash_attribute: 'payload.subscriptionId'
      references_one :destination, hash_attribute: 'payload'
    end
  end
end
