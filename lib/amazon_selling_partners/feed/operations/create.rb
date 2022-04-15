# frozen_string_literal: true

module AmazonSellingPartners
  class Feed
    class Operation
      class Create < AmazonSellingPartners::Operation::Create
        private

        def request_method
          :post
        end

        def url
          '/feeds/2021-06-30/feeds'
        end

        def opts
          {
            body:,
            header_params: {
              'content-type' => 'application/json'
            },
            form_params:,
            query_params:
          }
        end

        def body
          {
            feedType: resource.feed_type,
            marketplaceIds: [resource.market_place_id],
            inputFeedDocumentId: resource.feed_document.feed_document_id
          }
        end

        def query_params
          {}
        end

        def form_params
          {}
        end
      end
    end
  end
end
