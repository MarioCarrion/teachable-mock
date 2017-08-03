# frozen_string_literal: true

module Teachable
  module Mock
    class Configuration
      INVALID_VALUE  = 'Invalid value'
      REQUIRED_VALUE = 'Value is required'

      DEFAULT_OPEN_TIMEOUT = 0.07
      DEFAULT_READ_TIMEOUT = 0.07

      attr_reader :hostname

      def hostname=(value)
        raise ArgumentError, REQUIRED_VALUE if value.to_s.strip.length.zero?

        @hostname = value
      end

      def open_timeout
        @open_timeout ||= DEFAULT_OPEN_TIMEOUT
      end

      def open_timeout=(val)
        f_val = val.to_f
        raise ArgumentError, INVALID_VALUE if f_val.zero?

        @open_timeout = f_val
      end

      def read_timeout
        @read_timeout ||= DEFAULT_READ_TIMEOUT
      end

      def read_timeout=(val)
        f_val = val.to_f
        raise ArgumentError, INVALID_VALUE if f_val.zero?

        @read_timeout = f_val
      end
    end # class
  end
end
