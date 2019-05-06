require_relative "./lib/system_settings/version"

Gem::Specification.new do |s|
  s.name = "system_settings"
  s.version = SystemSettings::VERSION
  s.authors = ["Krists Ozols"]
  s.email = ["krists.ozols@gmail.com"]
  s.homepage = "https://github.com/krists/system_settings"
  s.summary = "Settings for your Rails application"
  s.description = <<-DESCRIPTION
    SystemSettings is a Rails engine that adds settings functionality.
    Initial setting values can be loaded from file and later edited in a SystemSettings provided admin panel.
  DESCRIPTION
  s.license = "MIT"
  s.files = Dir["{app,config,db,lib}/**/*", "frontend/build/**/*", "MIT-LICENSE", "README.md"]
  s.add_dependency "rails", ">= 5.0"
end
