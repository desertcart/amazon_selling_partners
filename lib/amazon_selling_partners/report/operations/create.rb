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
          hash = {
            reportType: resource.report_type,
            marketplaceIds: [resource.marketplace_id],
          }
          hash[:dataStartTime] = resource.data_start_time if resource.data_start_time.present?
          hash[:dataEndTime] = resource.data_end_time if resource.data_end_time.present?
          hash
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
