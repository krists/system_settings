require "simplecov"
SimpleCov.start do
  add_filter "test"
end
SimpleCov.command_name "test"

ENV["RAILS_ENV"] = "test"
require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"
require "minitest/mock"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
fixtures_path = File.expand_path("fixtures", __dir__)
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [fixtures_path]
  ActionDispatch::IntegrationTest.fixture_paths = [fixtures_path]
  ActiveSupport::TestCase.fixtures :all
elsif ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = fixtures_path
  ActionDispatch::IntegrationTest.fixture_path = fixtures_path
  ActiveSupport::TestCase.fixtures :all
end
ActiveSupport::TestCase.file_fixture_path = fixtures_path + "/files" if ActiveSupport::TestCase.respond_to?(:file_fixture_path=)
