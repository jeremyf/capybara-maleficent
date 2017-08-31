module Capybara
  module Maleficent
    class Logger
      def info(*args)
        $stdout.puts("INFO: #{args.inspect}")
      end

      def debug(*args)
        $stdout.puts("DEBUG: #{args.inspect}")
      end

      def error(*args)
        $stdout.puts("ERROR: #{args.inspect}")
      end

      def warn(*args)
        $stdout.puts("WARN: #{args.inspect}")
      end
    end
  end
end
