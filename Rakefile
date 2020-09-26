begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "SystemSettings"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)

load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  test_pattern = Rake::FileList["test/**/*_test.rb"]
  test_pattern.exclude("test/system/**/*", "test/dummy/**/*")
  t.pattern = test_pattern
  t.verbose = false
end

if ([Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join(".") == "5.0") && !Rake::Task.task_defined?("app:test:system")
  task "app:test:system" do
    warn "You are running Rails 5.0. System tests where added to Rails in version 5.1. Doing nothing.."
  end
end

load "webdrivers/tasks/chromedriver.rake"