# frozen_string_literal: true

require_relative '../operation'

module AmazonSellingPartners
  class Operation
    class Searcher
      include AmazonSellingPartners::Operation::Mixin

      def operate
        return failure(response.body&.[]('errors') || 'AmazonSellingPartners api request failed') if response.failure?

        success(
          resource: deserializer.deserialize(
            hash: response.body,
            resource:
          ),
          response: response.body
        )
      end

      private

      def response
        @response ||= client.api(request_method, url, opts)
      end

      def url
        raise NotImplementedError, self.class.name
      end

      def opts
        raise NotImplementedError, self.class.name
      end
    end
  end
end
