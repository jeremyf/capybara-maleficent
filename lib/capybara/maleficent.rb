require "capybara/maleficent/version"
require "capybara/maleficent/configuration"

module Capybara
  module Maleficent
    # @api public
    #
    # A method that wraps the given block in a retry sleep strategy. Of particular use for waiting on Capybara.
    #
    # @param the_sleeper [#sleep] What will be doing the sleeping; default is Kernel
    # @param logger [#debug, #info]
    # @param sleep_durations [Array<Integer>] The size of the array represents the max number of sleep attempts, each element represents how long
    # @param handled_exceptions [Array<Exceptions] Which exceptions should the sleep injector handle
    # @yield The block of code for which we will allow sleeping
    # @return The value of the given block
    # @see ./spec/lib/capybara/maleficent_spec.rb for specifications of behavior
    def self.with_sleep_injection(the_sleeper: Kernel, logger: configuration.logger, sleep_durations: configuration.sleep_durations, handled_exceptions: configuration.handled_exceptions)
      logger.debug "Starting Capybara::Maleficent.with_sleep_injection"
      sleep_durations = sleep_durations.clone
      last_try_sleep_duration = sleep_durations.pop
      return_value = nil
      success = false
      sleep_durations.each do |sleep_duration|
        begin
          return_value = yield.tap { success = true }
          break if success
        rescue *handled_exceptions
          logger.info "Sleeping for #{sleep_duration} via Capybara::Maleficent.with_sleep_injection (for #{handled_exceptions.inspect})"
          the_sleeper.sleep(sleep_duration)
          next
        end
      end
      if success
        logger.debug "Ending Capybara::Maleficent.with_sleep_injection"
        return return_value
      else
        logger.info "Sleeping for #{last_try_sleep_duration}via Capybara::Maleficent.with_sleep_injection (for #{handled_exceptions.inspect}). This is the last try."
        the_sleeper.sleep(last_try_sleep_duration)
        yield.tap do
          logger.debug "Ending Capybara::Maleficent.with_sleep_injection"
        end
      end
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
