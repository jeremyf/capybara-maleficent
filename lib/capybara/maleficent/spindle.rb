# Avoiding circular references
require "capybara/maleficent" unless defined?(Capybara::Maleficent)
unless defined?(Capybara::Maleficent::Spindle)
  # @note Establishing a namespace.
  module Capybara::Maleficent::Spindle
  end

  require "capybara/rspec/matchers"
  require "capybara/node/matchers"

  # Re-open these classes as `super` was not working
  class Capybara::RSpecMatchers::Matcher
    def wrap_matches?(actual)
      Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
        wrap(actual)
      end
    rescue Capybara::ExpectationNotMet => e
      @failure_message = e.message
      return false
    end
  end

  module Capybara::Node::Matchers
    def has_selector?(*args, &optional_filter_block)
      Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
        assert_selector(*args, &optional_filter_block)
      end
    rescue Capybara::ExpectationNotMet
      false
    end

    def has_no_selector?(*args, &optional_filter_block)
      Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
        assert_no_selector(*args, &optional_filter_block)
      end
    rescue Capybara::ExpectationNotMet
      false
    end
  end
end
