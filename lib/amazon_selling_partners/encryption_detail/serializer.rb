# frozen_string_literal: true

module AmazonSellingPartners
  class EncryptionDetail
    class Serializer < AmazonSellingPartners::Serializer
      attribute :key
      attribute :standard
      attribute :initialization_vector
    end
  end
end
