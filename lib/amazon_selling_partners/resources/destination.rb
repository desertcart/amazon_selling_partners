# frozen_string_literal: true

module AmazonSellingPartners
  class Destination < AmazonSellingPartners::Resource
    attribute :id, type: LedgerSync::Type::String
    attribute :name, type: LedgerSync::Type::String
    attribute :sqs_arn, type: LedgerSync::Type::String
  end
end
