# frozen_string_literal: true

require 'uri'
require_relative '../../operation/classified_errors'

module AmazonSellingPartners
  class ListingsRestrictions
    class Operation
      # getListingsRestrictions for one ASIN, seller and marketplace.
      class Find < AmazonSellingPartners::Operation::Find
        include AmazonSellingPartners::Operation::ClassifiedErrors

        private

        def request_method
          :get
        end

        def url
          query = {
            asin: resource.asin, sellerId: resource.seller_id,
            marketplaceIds: resource.marketplace_id, reasonLocale: 'en_US',
            conditionType: resource.condition_type.presence ||
                           AmazonSellingPartners::ListingsRestrictions::DEFAULT_CONDITION_TYPE
          }
          "/listings/2021-08-01/restrictions?#{URI.encode_www_form(query)}"
        end

        def opts
          { body: nil, header_params: {}, form_params: {}, query_params: {} }
        end
      end
    end
  end
end
