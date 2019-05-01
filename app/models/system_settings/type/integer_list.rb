module SystemSettings
  module Type
    class IntegerList < ActiveModel::Type::Value
      SEPARATOR = ";".freeze

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
          value.map { |v| v.to_i rescue nil }
        when String
          value.split(SEPARATOR).map { |v| v.to_i rescue nil }
        else
          nil
        end
      end
    end
  end
end
