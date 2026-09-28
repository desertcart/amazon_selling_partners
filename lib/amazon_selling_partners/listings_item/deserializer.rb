# frozen_string_literal: true

module AmazonSellingPartners
  class ListingsItem
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :status, hash_attribute: 'status'
      attribute :submission_id, hash_attribute: 'submissionId'
      attribute :issues, hash_attribute: 'issues'
      attribute :summaries, hash_attribute: 'summaries'
    end
  end
end
