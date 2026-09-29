# frozen_string_literal: true

require_relative '../../operation/classified_errors'
require_relative 'item_path'

module AmazonSellingPartners
  class ListingsItem
    class Operation
      # putListingsItem: creates a listing or replaces its content. With
      # requirements LISTING_OFFER_ONLY and a merchant_suggested_asin it creates
      # an offer on an existing catalog item. Replacing drops omitted
      # attributes, so only use it for SKUs that don't exist yet.
      #
      # The resource comes back with status (ACCEPTED, INVALID, or VALID in
      # VALIDATION_PREVIEW mode), submission_id and issues.
      class Put < AmazonSellingPartners::Operation::Update
        include AmazonSellingPartners::Operation::ClassifiedErrors
        include ItemPath

        private

        def request_method
          :put
        end

        def url
          item_path(marketplaceIds: resource.marketplace_id, includedData: 'issues',
                    mode: resource.mode.presence)
        end

        def opts
          {
            body:,
            header_params: { 'Content-Type' => 'application/json' },
            form_params: {},
            query_params: {}
          }
        end

        def body
          {
            productType: resource.product_type,
            requirements: resource.requirements.presence,
            attributes: resource.listing_attributes
          }.compact
        end
      end
    end
  end
end
