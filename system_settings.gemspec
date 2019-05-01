$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "system_settings/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "system_settings"
  s.version     = SystemSettings::VERSION
  s.authors     = ["Krists Ozols"]
  s.email       = ["krists.ozols@gmail.com"]
  s.homepage    = "https://github.com/krists/system_settings"
  s.summary     = "Summary of SystemSettings."
  s.description = "Description of SystemSettings."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "frontend/build/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "pry"
  s.add_development_dependency "sqlite3", "~> 1.3.13"
  s.add_development_dependency "i18n-debug"
end
