require "bundler/setup"

GEM_ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift File.join(GEM_ROOT, 'lib')

require 'rspec'
require 'capybara/maleficent'

class Capybara::Maleficent::NullLogger
  def debug(*args); end
  def info(*args); end
  def warn(*args); end
  def error(*args); end
end

Capybara::Maleficent.configure do |config|
  config.logger = Capybara::Maleficent::NullLogger.new
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
