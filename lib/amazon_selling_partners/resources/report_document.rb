# frozen_string_literal: true

require_relative 'feed_content'
require_relative '../types/array'

module AmazonSellingPartners
  class ReportDocument < AmazonSellingPartners::Resource
    attribute :url, type: LedgerSync::Type::String
    attribute :report_document_id, type: LedgerSync::Type::String
  end
end
