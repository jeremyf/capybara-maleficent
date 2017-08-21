require "capybara/maleficent/version"
require "capybara/maleficent/configuration"

module Capybara
  module Maleficent
    # @api public
    #
    # A method that wraps the given block in a retry sleep strategy. Of particular use for waiting on Capybara.
    #
    # @param [#sleep] the_sleeper - What will be doing the sleeping; default is Kernel
    # @param [Array<Integer>] sleep_durations - The size of the array represents the max number of sleep attempts, each element represents how long
    # @param [Array<Exceptions] handled_exceptions - Which exceptions should the sleep injector handle
    # @yield The block of code for which we will allow sleeping
    # @return The value of the given block
    # @see ./spec/lib/capybara/maleficent_spec.rb for specifications of behavior
    def self.with_sleep_injection(the_sleeper: Kernel, sleep_durations: configuration.sleep_durations, handled_exceptions: configuration.handled_exceptions)
      sleep_durations = sleep_durations.clone
      last_try_sleep_duration = sleep_durations.pop
      return_value = nil
      success = false
      sleep_durations.each do |sleep_duration|
        begin
          return_value = yield.tap { success = true }
          break if success
        rescue *handled_exceptions
          the_sleeper.sleep(sleep_duration)
          next
        end
      end
      return return_value if success
      the_sleeper.sleep(last_try_sleep_duration)
      yield
    end

    def self.default_sleeper
      Kernel
    end

    def self.configuration
      @configuration || Configuration.new
    end

    def self.config
      @configuration = Configuration.new
      yield(@configuration)
      @configuration
    end
  end
end
