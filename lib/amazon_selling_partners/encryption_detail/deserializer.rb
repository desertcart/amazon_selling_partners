# frozen_string_literal: true

module AmazonSellingPartners
  class EncryptionDetail
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :key
      attribute :standard
      attribute :initialization_vector, hash_attribute: 'initializationVector'
    end
  end
end
