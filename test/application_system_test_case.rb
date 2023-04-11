require "test_helper"
require "webdrivers/chromedriver"

SimpleCov.command_name "test:system"

WEBDRIVERS_INSTALL_DIR = File.join(File.expand_path("..", __dir__), "tmp", "webdrivers").to_s
CAPYBARA_SCREENSHOTS_DIR = File.join(File.expand_path("..", __dir__), "tmp", "screenshots").to_s

FileUtils.mkdir_p(WEBDRIVERS_INSTALL_DIR)
FileUtils.mkdir_p(CAPYBARA_SCREENSHOTS_DIR)

Webdrivers.install_dir = WEBDRIVERS_INSTALL_DIR
Webdrivers.cache_time = 86_400

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  screen_size = [1920, 1080]

  driven_by :selenium, using: :headless_chrome, screen_size: screen_size

  def absolute_image_path
    Pathname.new(File.join(CAPYBARA_SCREENSHOTS_DIR, "#{image_name}.png"))
  end
end
