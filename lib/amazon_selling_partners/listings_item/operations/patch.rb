# frozen_string_literal: true

module AmazonSellingPartners
  class ListingsItem
    class Operation
      class Patch < AmazonSellingPartners::Operation::Update
        private

        def request_method
          :patch
        end

        def url
          "/listings/2021-08-01/items/#{resource.seller_id}/#{resource.sku}" \
            "?marketplaceIds=#{resource.marketplace_id}"
        end

        def opts
          {
            body:,
            header_params: {
              'Content-Type' => 'application/json'
            },
            form_params: {},
            query_params: {}
          }
        end

        def body
          {
            productType: resource.product_type,
            patches: resource.patches
          }
        end
      end
    end
  end
end
