# frozen_string_literal: true

module AmazonSellingPartners
  class Report < AmazonSellingPartners::Resource
    REPORT_TYPES = {
      values: %w[
        GET_MERCHANT_LISTINGS_DATA
        GET_MERCHANT_LISTINGS_INACTIVE_DATA
      ]
    }.freeze

    attribute :report_id, type: LedgerSync::Type::String
    attribute :processing_status, type: LedgerSync::Type::String
    attribute :report_document_id, type: LedgerSync::Type::String
    attribute :report_type, type: LedgerSync::Type::StringFromSet.new(REPORT_TYPES)
    attribute :marketplace_id, type: LedgerSync::Type::String
  end
end
