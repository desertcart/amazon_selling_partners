# frozen_string_literal: true

module AmazonSellingPartners
  class Destination
    class Operation
      class Create < AmazonSellingPartners::Operation::Create
        private

        def request_method
          :post
        end

        def url
          '/notifications/v1/destinations'
        end

        def opts # rubocop:disable Metrics/MethodLength
          {
            body: {
              name: resource.name,
              resourceSpecification: {
                sqs: {
                  arn: resource.sqs_arn,
                }
              }
            },
            form_params: {},
            query_params: {}
          }
        end
      end
    end
  end
end
