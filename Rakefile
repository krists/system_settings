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
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

Rake::Task["clean"].enhance do
  frontend_build_dir = File.join(__dir__, "frontend", "build")
  Pathname.new(frontend_build_dir).children.each(&:rmtree)
end

require "open3"
require "active_support/tagged_logging"

class YarnCommand
  def initialize(*command)
    @command = command
    @logger = ActiveSupport::TaggedLogging.new(Logger.new(STDERR))
  end

  attr_reader :command, :logger

  def run
    Open3.popen3(*command, chdir: File.join(__dir__, "frontend")) do |stdin, stdout, stderr, wait_thread|
      stdin.close_write

      stdout_thread = Thread.new do
        until stdout.eof?
          line = stdout.gets
          logger.tagged("YARN", "STDOUT") { logger.debug(line.rstrip) }
        end
      rescue IOError
        nil
      end
      stdout_thread.abort_on_exception = true

      stderr_thread = Thread.new do
        until stderr.eof?
          line = stderr.gets
          logger.tagged("YARN", "STDERR") { logger.debug(line.rstrip) }
        end
      rescue IOError
        nil
      end
      stderr_thread.abort_on_exception = true

      wait_thread.join

      exit(1) unless wait_thread.value.exitstatus.zero?
    end
  end
end

namespace :frontend do
  desc "Build frontend component"
  task :build do
    YarnCommand.new("yarn build").run
  end

  desc "Install frontend dependencies"
  task :install do
    YarnCommand.new("yarn install").run
  end
end

Rake::Task[:build].enhance [:"frontend:build"]

task default: :test
