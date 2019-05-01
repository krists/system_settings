require "system_settings/engine"

module SystemSettings
  def self.[](name)
    Setting.find_by!(name: name).value
  end
end
