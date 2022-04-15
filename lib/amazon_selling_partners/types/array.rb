# frozen_string_literal: true

module AmazonSellingPartners
  module Type
    class Array < LedgerSync::Type::Value # :nodoc:
      include LedgerSync::Type::ValueMixin

      def cast?
        true
      end

      def changed_in_place?(raw_old_value, new_value)
        raw_old_value != new_value if new_value.is_a?(::Array)
      end

      def type
        :id
      end

      def valid_classes
        [::Array]
      end

      private

      def cast_value(args = {})
        value = args.fetch(:value)

        case value
        when ::Array then value.clone
        else [value]
        end
      end
    end
  end
end
