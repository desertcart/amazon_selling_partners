# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'csv'

module AmazonSellingPartners
  class FeedDocument
    class Operation
      class Update < AmazonSellingPartners::Operation::Update
        def operate
          return failure(response.body&.[]('errors') || 'AmazonSellingPartners api request failed') if response.failure?

          success(
            resource: nil,
            response: response.body
          )
        end

        # NOTE: Leave this accessible so we can log generated CSV.
        def generated_csv
          @generated_csv ||= CSV.generate(col_sep: "\t", encoding: 'UTF-8') do |csv|
            csv << csv_header
            resource.feed_contents.each do |feed_content|
              csv << csv_row_for(feed_content:)
            end
          end
        end

        private

        def response # rubocop:disable Metrics/MethodLength
          @response ||= begin
            request = Typhoeus::Request.new(
              resource.url,
              method: :put,
              headers: { 'content-type' => 'text/tsv' },
              body: generated_csv
            )
            request.run

            AmazonSellingPartners::Response.new_from_typhoeus_response(
              typhoeus_response: request.response,
              request:
            )
          end
        end

        def csv_header
          resource.content_attributes.map do |attr|
            attr.to_s.gsub('_', '-')
          end
        end

        def csv_row_for(feed_content:)
          resource.content_attributes.map do |attr|
            feed_content.try(attr)
          end
        end
      end
    end
  end
end
