# frozen_string_literal: true

module AmazonSellingPartners
  class Report
    class Deserializer < LedgerSync::Deserializer
      attribute :report_id, hash_attribute: 'reportId'
      attribute :processing_status, hash_attribute: 'processingStatus'
      attribute :report_document_id, hash_attribute: 'reportDocumentId'
    end
  end
end
