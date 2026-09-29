# frozen_string_literal: true

require_relative '../../operation/classified_errors'
require_relative 'item_path'

module AmazonSellingPartners
  class ListingsItem
    class Operation
      # deleteListingsItem: removes the seller's listing for a SKU on the
      # marketplace. The resource comes back with status (ACCEPTED or INVALID),
      # submission_id and issues; a SKU the seller doesn't have fails with
      # Errors::NotFound.
      class Delete < AmazonSellingPartners::Operation::Delete
        include AmazonSellingPartners::Operation::ClassifiedErrors
        include ItemPath

        private

        def request_method
          :delete
        end

        def url
          item_path(marketplaceIds: resource.marketplace_id)
        end

        def opts
          { body: nil, header_params: {}, form_params: {}, query_params: {} }
        end
      end
    end
  end
end
