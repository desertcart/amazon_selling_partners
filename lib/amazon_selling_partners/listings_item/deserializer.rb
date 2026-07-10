# frozen_string_literal: true

module AmazonSellingPartners
  class ListingsItem
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :status, hash_attribute: 'status'
      attribute :submission_id, hash_attribute: 'submissionId'
    end
  end
end
