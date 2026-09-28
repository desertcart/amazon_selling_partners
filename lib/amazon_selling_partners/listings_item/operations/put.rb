# frozen_string_literal: true

require 'uri'
require_relative '../../operation/classified_errors'

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

        private

        def request_method
          :put
        end

        def url
          query = { marketplaceIds: resource.marketplace_id, includedData: 'issues',
                    mode: resource.mode.presence }.compact
          "/listings/2021-08-01/items/#{resource.seller_id}/#{escaped_sku}" \
            "?#{URI.encode_www_form(query)}"
        end

        # A path segment: spaces become %20, not +.
        def escaped_sku
          URI.encode_www_form_component(resource.sku).gsub('+', '%20')
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
