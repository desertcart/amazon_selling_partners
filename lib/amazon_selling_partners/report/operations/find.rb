# frozen_string_literal: true

module AmazonSellingPartners
  class Report
    class Operation
      class Find < AmazonSellingPartners::Operation::Find
        private

        def request_method
          :get
        end

        def url
          "/reports/2021-06-30/reports/#{resource.report_id}"
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
