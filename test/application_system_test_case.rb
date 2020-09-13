require "test_helper"
require "webdrivers/chromedriver"

SimpleCov.command_name 'test:system'

WEBDRIVERS_INSTALL_DIR = File.join(File.expand_path("..", __dir__), "tmp", "webdrivers").to_s
CAPYBARA_SCREENSHOTS_DIR = File.join(File.expand_path("..", __dir__), "tmp", "screenshots").to_s

FileUtils.mkdir_p(WEBDRIVERS_INSTALL_DIR)
FileUtils.mkdir_p(CAPYBARA_SCREENSHOTS_DIR)

Webdrivers.install_dir = WEBDRIVERS_INSTALL_DIR
Webdrivers.cache_time = 86_400

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  screen_size = [1920, 1080]

  # Rails 5.1 does not handle :headless_chrome browser type
  # so we have to manually setup headless mode
  if [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join(".") == "5.1"
    options = Selenium::WebDriver::Chrome::Options.new
    options.args << "--headless"
    options.args << "--disable-gpu" if Gem.win_platform?
    driven_by :selenium, using: :chrome, screen_size: screen_size, options: { options: options }
  else
    driven_by :selenium, using: :headless_chrome, screen_size: screen_size
  end

  def absolute_image_path
    Pathname.new(File.join(CAPYBARA_SCREENSHOTS_DIR, "#{image_name}.png"))
  end
end
