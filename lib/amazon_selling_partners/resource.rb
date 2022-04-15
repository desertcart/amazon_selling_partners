# frozen_string_literal: true

module AmazonSellingPartners
  class Resource < LedgerSync::Resource
    def serialize
      result = {}
      to_h.each_key do |key|
        result[key] = to_h[key].try(:to_h) || to_h[key]
      end
      result
    end
  end
end
