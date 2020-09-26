# frozen_string_literal: true

module SystemSettings::Type
  class IntegerList < ActiveModel::Type::Value
    SEPARATOR = ";"

    def initialize(precision: nil, limit: nil, scale: nil)
      super
      @single_type = ActiveModel::Type::Integer.new(precision: precision, limit: limit, scale: scale)
    end

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
        value.map { |v| @single_type.cast(v) }
      when String
        value.split(SEPARATOR).map { |v| @single_type.cast(v) }
      end
    end
  end
end
