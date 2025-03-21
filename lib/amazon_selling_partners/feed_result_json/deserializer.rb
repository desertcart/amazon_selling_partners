# frozen_string_literal: true

module AmazonSellingPartners
  class FeedResultJson
    class Deserializer < Deserializer
      attribute :processed, hash_attribute: 'summary.messagesProcessed'
      attribute :successful, hash_attribute: 'summary.messagesAccepted'
      attribute :ledger_errors do |response|
        response[:hash]['issues']&.map do |issue|
          {
            message_id: issue["messageId"],
            code: issue["code"],
            severity: issue["severity"],
            message: issue["message"],
            attribute_name: issue["attributeName"]
          }
        end
      end
    end
  end
end
