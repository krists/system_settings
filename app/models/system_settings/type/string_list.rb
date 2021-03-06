# frozen_string_literal: true

module SystemSettings::Type
  class StringList < ActiveModel::Type::Value
    DELIMITER_REGEXP = /(?<=[^\\]);/.freeze
    def type
      :string_list
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
        value.map { |v| String(v).strip }
      when String
        value.split(DELIMITER_REGEXP).map(&:strip).map { |str| str.gsub("\\;", ";") }
      end
    end
  end
end
