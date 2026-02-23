# frozen_string_literal: true

module AmazonSellingPartners
  class Report < AmazonSellingPartners::Resource
    REPORT_TYPES = {
      values: %w[
        GET_MERCHANT_LISTINGS_DATA
        GET_MERCHANT_LISTINGS_INACTIVE_DATA
        GET_FLAT_FILE_ALL_ORDERS_DATA_BY_LAST_UPDATE_GENERAL
      ]
    }.freeze

    attribute :report_id, type: LedgerSync::Type::String
    attribute :processing_status, type: LedgerSync::Type::String
    attribute :report_document_id, type: LedgerSync::Type::String
    attribute :report_type, type: LedgerSync::Type::StringFromSet.new(REPORT_TYPES)
    attribute :marketplace_id, type: LedgerSync::Type::String
    attribute :data_start_time, type: LedgerSync::Type::String
    attribute :data_end_time, type: LedgerSync::Type::String
  end
end
