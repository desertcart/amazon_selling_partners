# frozen_string_literal: true

module AmazonSellingPartners
  class FeedResult
    class Deserializer < AmazonSellingPartners::Deserializer
      attribute :processed do |response|
        processed_re = response[:hash].match(/Number of records processed\t\t(\d*)\n/)
        processed_re ? processed_re.captures.first.to_i : nil
      end
      attribute :successful do |response|
        successful_re = response[:hash].match(/Number of records successful\t\t(\d*)\n/)
        successful_re ? successful_re.captures.first.to_i : nil
      end
      attribute :ledger_errors do |response|
        seperator = "original-record-number\tsku\terror-code\terror-type\terror-message\n"
        (_stats, errors_raw) = response[:hash].split(seperator)
        if errors_raw
          errors_raw.split("\n").map do |row|
            (original_record_number, sku, error_code, error_type, error_message) = row.split("\t")
            { original_record_number:, sku:, error_code:, error_type:, error_message: }
          end
        else
          [{ error_message: 'Could not parse errors' }]
        end
      end
    end
  end
end
