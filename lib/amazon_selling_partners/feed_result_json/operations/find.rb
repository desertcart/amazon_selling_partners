# frozen_string_literal: true

module AmazonSellingPartners
  class FeedResultJson
    class Operation
      class Find < AmazonSellingPartners::Operation::Find
        private

        def response
          @response ||= begin
                          request = Typhoeus::Request.new(url, method: :get)
                          request.run
                          typhoeus_response = request.response

                          AmazonSellingPartners::Response.new(
                            body: typhoeus_response.success? ? ungzip(typhoeus_response.body) : typhoeus_response.body,
                            headers: typhoeus_response.headers,
                            raw: typhoeus_response,
                            request:,
                            status: typhoeus_response.code,
                            message: typhoeus_response.status_message
                          )
                        end
        end

        def ungzip(body)
          Zlib::GzipReader.new(StringIO.new(body)).read
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
