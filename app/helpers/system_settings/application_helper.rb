module SystemSettings::ApplicationHelper
  SEPARATOR = ";".freeze

  def format_value(value)
    if value.respond_to?(:each)
      capture do
        value.each do |v|
          concat content_tag(:span, v, class: "value-part")
        end
      end
    else
      value
    end
  end

  def format_value_for_form(record)
    case record
    when SystemSettings::StringListSetting
      record.value.map { |v| v.gsub(SEPARATOR, "\\#{SEPARATOR}") }.join(SEPARATOR)
    when SystemSettings::IntegerListSetting, SystemSettings::DecimalListSetting
      record.value.join(SEPARATOR)
    else
      record.value
    end
  end

  def display_settings_file_path
    if SystemSettings.settings_file_path.to_s.include?(Rails.root.to_s)
      Pathname.new(SystemSettings.settings_file_path).relative_path_from(Rails.root)
    else
      SystemSettings.settings_file_path
    end
  end
end
