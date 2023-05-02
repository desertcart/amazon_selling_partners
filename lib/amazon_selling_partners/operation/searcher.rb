# frozen_string_literal: true

require_relative '../operation'

module AmazonSellingPartners
  class Operation
    class Searcher < LedgerSync::Ledgers::Searcher
      def perform
        return failure if response.failure?

        success
      end

      def deserialized_resource(hash:)
        searcher_deserializer.deserialize(
          hash: hash,
          resource: resource_class.new
        )
      end

      def resource_class
        @resource_class ||= self.class.inferred_resource_class
      end

      def searcher_deserializer_class
        @searcher_deserializer_class ||= self.class.inferred_serialization_class(
          type: 'SearcherDeserializer'
        )
      end

      def searcher_deserializer
        searcher_deserializer_class.new
      end

      def response
        @response ||= client.api(request_method, url, opts)
      end

      def resources
        raise NotImplementedError, self.class.name
      end

      def next_token
        raise NotImplementedError, self.class.name
      end

      private

      def url
        raise NotImplementedError, self.class.name
      end

      def opts
        raise NotImplementedError, self.class.name
      end
    end
  end
end
