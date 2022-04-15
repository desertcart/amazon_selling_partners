# frozen_string_literal: true

module AmazonSellingPartners
  class FeedResult
    class Operation
      class Find < AmazonSellingPartners::Operation::Find
        private

        def response
          @response ||= begin
            request = Typhoeus::Request.new(url, method: :get)
            request.run

            AmazonSellingPartners::Response.new_from_typhoeus_response(
              typhoeus_response: request.response,
              request:
            )
          end
        end

        def url
          resource.url
        end

        def opts
          {}
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
