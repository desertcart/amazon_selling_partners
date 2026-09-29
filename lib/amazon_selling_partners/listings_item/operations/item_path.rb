# frozen_string_literal: true

require 'uri'

module AmazonSellingPartners
  class ListingsItem
    class Operation
      # The listings item URL (seller and SKU) for the operation's resource.
      module ItemPath
        private

        def item_path(query)
          "/listings/2021-08-01/items/#{resource.seller_id}/#{escaped_sku}" \
            "?#{URI.encode_www_form(query.compact)}"
        end

        # A path segment: spaces become %20, not +.
        def escaped_sku
          URI.encode_www_form_component(resource.sku).gsub('+', '%20')
        end
      end
    end
  end
end
