# frozen_string_literal: true

require_relative '../../operation/classified_errors'
require_relative 'item_path'

module AmazonSellingPartners
  class ListingsItem
    class Operation
      # getListingsItem: the seller's listing for a SKU, with summaries and
      # issues. Fails with Errors::NotFound when the seller has no such SKU.
      class Find < AmazonSellingPartners::Operation::Find
        include AmazonSellingPartners::Operation::ClassifiedErrors
        include ItemPath

        private

        def request_method
          :get
        end

        def url
          item_path(marketplaceIds: resource.marketplace_id, includedData: 'summaries,issues')
        end

        def opts
          { body: nil, header_params: {}, form_params: {}, query_params: {} }
        end
      end
    end
  end
end
