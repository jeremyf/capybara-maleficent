# Avoiding circular references
require "capybara/maleficent" unless defined?(Capybara::Maleficent)
unless defined?(Capybara::Maleficent::Spindle)
  # @note Establishing a namespace.
  module Capybara::Maleficent::Spindle
  end

  require "capybara/node/matchers"
  module Capybara::Node::Matchers
    # I was encountering issues with module inclusion and super method. This is
    # an alternative to super. I grab the method (in this case instance method
    # because it's a module), redefine the method to wrap the original method.
    #
    # http://blog.jayfields.com/2008/04/alternatives-for-redefining-methods.html
    [
      :assert_selector,
      :assert_no_selector,
      :assert_matches_selector,
      :assert_not_matches_selector,
      :assert_text,
      :assert_no_text
    ].each do |method_name|
      original_method = instance_method(method_name)
      define_method method_name do |*args, &block|
        Capybara::Maleficent.with_sleep_injection(handled_exceptions: [Capybara::ExpectationNotMet]) do
          original_method.bind(self).call(*args, &block)
        end
      end
    end
  end
end
