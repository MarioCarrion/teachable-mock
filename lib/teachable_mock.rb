# frozen_string_literal: true

require 'net/http'
require 'uri'

Dir[File.join(File.expand_path('..', __FILE__), '**', '*.rb')].each do |f|
  require f
end

module Teachable
  module Mock
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def setup
        yield configuration if block_given?

        configuration
      end
    end # << self
  end
end
