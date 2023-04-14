# frozen_string_literal: true

module AmazonSellingPartners
  module Type
    class IsoDate < LedgerSync::Type::Date # :nodoc:
      def valid?(args = {})
        return false unless valid_class?(args)

        value = args.fetch(:value)
        return true unless value.is_a?(::String)
        return false unless value =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/

        true
      end
    end
  end
end
