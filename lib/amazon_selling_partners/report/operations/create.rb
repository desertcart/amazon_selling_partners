# frozen_string_literal: true

module AmazonSellingPartners
  class Report
    class Operation
      class Create < AmazonSellingPartners::Operation::Create
        private

        def request_method
          :post
        end

        def url
          '/reports/2021-06-30/reports'
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
            reportType: resource.report_type,
            marketplaceIds: [resource.marketplace_id],
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
