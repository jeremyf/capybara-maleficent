require 'active_support/core_ext/array/wrap'

module Capybara
  module Maleficent
    # Responsible for managing the configuration of Capybara::Maleficent
    class Configuration
      def initialize(**kargs)
        self.sleep_durations = kargs.fetch(:sleep_durations) { [3, 10] }
        self.handled_exceptions = kargs.fetch(:handled_exceptions) { [] }
      end

      attr_accessor :handled_exceptions

      # Used to determine the number of sleeps to attempt, and the duration of each of those sleeps.
      # @return An array of integers
      attr_reader :sleep_durations

      # @param [Array<#to_i>] input - An array of integers. The given input elements will be coerced to integers
      def sleep_durations=(input)
        @sleep_durations = Array.wrap(input).map(&:to_i)
      end
    end
  end
end
