# frozen_string_literal: true

module AmazonSellingPartners
  class Operation
    # For operations whose callers react per cause: failures come back as
    # Errors::RequestError subclasses (Unauthorized, NotFound, Throttled,
    # ServerError) instead of raw error bodies or exceptions.
    module ClassifiedErrors
      def operate
        return failure(Errors::RequestError.from_response(response)) if response.failure?

        success(resource: deserialized_resource, response: response.body)
      rescue Errors::AuthError => e
        failure(Errors::Unauthorized.from_auth_error(e))
      rescue Faraday::Error => e
        failure(Errors::ServerError.new(message: e.message))
      end

      private

      def deserialized_resource
        deserializer.deserialize(hash: response.body, resource:)
      end
    end
  end
end
