# frozen_string_literal: true

require 'net/http'
require 'uri'

module AmazonSellingPartners
  class FeedDocument
    class Operation
      class CreateJson < AmazonSellingPartners::Operation::Create
        private

        def request_method
          :post
        end

        def url
          '/feeds/2021-06-30/documents'
        end

        def opts
          {
            body: {
              contentType: 'application/json'
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
