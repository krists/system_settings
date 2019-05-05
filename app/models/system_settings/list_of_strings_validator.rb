module SystemSettings
  class ListOfStringsValidator < ActiveModel::EachValidator
    NON_WHITESPACE_REGEXP = /[^[:space:]]/.freeze

    def validate_each(record, attr_name, value)
      came_from_user = :"#{attr_name}_came_from_user?"

      if record.respond_to?(came_from_user) && record.public_send(came_from_user)
        raw_value = record.read_attribute_before_type_cast(attr_name)
      end
      raw_value ||= value

      if record_attribute_changed_in_place?(record, attr_name)
        raw_value = value
      end

      unless matches_list_of_strings_regexp?(raw_value)
        record.errors.add(attr_name, :not_a_list_of_strings)
        return
      end
    end

    private

    def record_attribute_changed_in_place?(record, attr_name)
      record.respond_to?(:attribute_changed_in_place?) &&
          record.attribute_changed_in_place?(attr_name.to_s)
    end

    def matches_list_of_strings_regexp?(raw_value)
      case raw_value
      when String
        raw_value.split(SystemSettings::Type::StringList::DELIMITER_REGEXP).all? do |value|
          NON_WHITESPACE_REGEXP.match?(value)
        end
      when Array
        raw_value.all? { |v| NON_WHITESPACE_REGEXP.match?(v.to_s) }
      else
        false
      end
    end
  end
end
