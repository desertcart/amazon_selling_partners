# frozen_string_literal: true

require 'uri'
require_relative '../../operation/classified_errors'

module AmazonSellingPartners
  class ListingsItem
    class Operation
      # getListingsItem: the seller's listing for a SKU, with summaries and
      # issues. Fails with Errors::NotFound when the seller has no such SKU.
      class Find < AmazonSellingPartners::Operation::Find
        include AmazonSellingPartners::Operation::ClassifiedErrors

        private

        def request_method
          :get
        end

        def url
          query = { marketplaceIds: resource.marketplace_id, includedData: 'summaries,issues' }
          "/listings/2021-08-01/items/#{resource.seller_id}/#{escaped_sku}" \
            "?#{URI.encode_www_form(query)}"
        end

        # A path segment: spaces become %20, not +.
        def escaped_sku
          URI.encode_www_form_component(resource.sku).gsub('+', '%20')
        end

        def opts
          { body: nil, header_params: {}, form_params: {}, query_params: {} }
        end
      end
    end
  end
end
