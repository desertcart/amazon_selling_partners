# frozen_string_literal: true

require_relative '../encryption_detail/deserializer'

module AmazonSellingPartners
  class ReportDocument
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :url
      attribute :report_document_id, hash_attribute: 'reportDocumentId'
    end
  end
end
