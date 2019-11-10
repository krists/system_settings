# frozen_string_literal: true

module SystemSettings
  module Type
    class DecimalList < ActiveModel::Type::Value
      SEPARATOR = ";"

      def initialize(precision: nil, limit: nil, scale: nil)
        super
        @single_type = ActiveModel::Type::Decimal.new(precision: precision, limit: limit, scale: scale)
      end

      def type
        :decimal_list
      end

      def deserialize(value)
        result = value.presence && JSON.parse(value)
        if result.is_a?(Array)
          result.map { |v| @single_type.cast(v) }
        else
          result
        end
      end

      def serialize(value)
        JSON.dump(value) unless value.nil?
      end

      private

      def cast_value(value)
        case value
        when Array
          value.map { |v| @single_type.cast(v) }
        when String
          value.split(SEPARATOR).map { |v| @single_type.cast(v) }
        end
      end
    end
  end
end
