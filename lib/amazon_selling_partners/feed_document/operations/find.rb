# frozen_string_literal: true

module AmazonSellingPartners
  class FeedDocument
    class Operation
      class Find < AmazonSellingPartners::Operation::Find
        private

        def request_method
          :get
        end

        def url
          "/feeds/2021-06-30/documents/#{resource.feed_document_id}"
        end

        def opts
          {
            body: nil,
            header_params: {
              'content-type' => 'application/json'
            },
            form_params:,
            query_params:
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
