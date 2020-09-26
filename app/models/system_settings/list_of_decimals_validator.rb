# frozen_string_literal: true

class SystemSettings::ListOfDecimalsValidator < ActiveModel::EachValidator
  LIST_REGEXP = /\A[+-]?\d+(?:\.\d+){0,1}(?:; *[+-]?\d+(?:\.\d+){0,1})*\z/.freeze
  SINGLE_REGEXP = /\A[+-]?\d+(?:\.\d+){0,1}\z/.freeze

  def validate_each(record, attr_name, value)
    came_from_user = :"#{attr_name}_came_from_user?"

    raw_value = record.read_attribute_before_type_cast(attr_name) if record.respond_to?(came_from_user) && record.public_send(came_from_user)
    raw_value ||= value

    raw_value = value if record_attribute_changed_in_place?(record, attr_name)

    record.errors.add(attr_name, :not_a_list_of_decimals) unless matches_list_of_decimals_regexp?(raw_value)
  end

  private

  def record_attribute_changed_in_place?(record, attr_name)
    record.respond_to?(:attribute_changed_in_place?) &&
      record.attribute_changed_in_place?(attr_name.to_s)
  end

  def matches_list_of_decimals_regexp?(raw_value)
    case raw_value
    when String
      LIST_REGEXP.match?(raw_value)
    when Array
      raw_value.all? { |v| SINGLE_REGEXP.match?(v.to_s) }
    else
      false
    end
  end
end
