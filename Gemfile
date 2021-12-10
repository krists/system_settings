source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "master")

rails = case rails_version
        when "master"
          {github: "rails/rails"}
        else
          "~> #{rails_version}"
        end

gem "rails", rails

sqlite3_version = ENV.fetch("SQLITE3_VERSION", "1.4")

gem "sqlite3", "~> #{sqlite3_version}"

sprockets_version = ENV.fetch("SPROCKETS_VERSION", "4.0.2")

gem "sprockets", "~> #{sprockets_version}"
gem "sprockets-rails"

gem "pry"
gem "rubocop"
gem "capybara", "~> 3.33"
gem "selenium-webdriver", "~> 3.142", ">= 3.142.7"
gem "webdrivers", "~> 4.0", ">= 4.4.1", require: false
gem "puma", "~> 4.0", ">= 4.0.0"
gem "simplecov", "~> 0.17.1", require: false
