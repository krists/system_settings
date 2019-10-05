# frozen_string_literal: true

module SystemSettings
  module Type
    class IntegerList < ActiveModel::Type::Value
      SEPARATOR = ";"

      def type
        :integer_list
      end

      def deserialize(value)
        value.presence && JSON.parse(value)
      end

      def serialize(value)
        JSON.dump(value) unless value.nil?
      end

      private

      def cast_value(value)
        case value
        when Array
          value.map do |v|
            begin
              v.to_i
            rescue StandardError
              nil
            end
          end
        when String
          value.split(SEPARATOR).map do |v|
            begin
              v.to_i
            rescue StandardError
              nil
            end
          end
        end
      end
    end
  end
end
