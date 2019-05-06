ENV["RAILS_ENV"] = "test"
require "pry"

puts <<~VERSIONS
  Testing with versions:
   * Rails #{Bundler.locked_gems.dependencies["rails"].to_spec.version}
   * SQLite3 #{Bundler.locked_gems.dependencies["sqlite3"].to_spec.version}

VERSIONS

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]

ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files" if ActiveSupport::TestCase.respond_to?(:file_fixture_path=)
  ActiveSupport::TestCase.fixtures :all
end
