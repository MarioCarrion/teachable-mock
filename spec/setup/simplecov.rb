# frozen_string_literal: true

require 'simplecov'
require 'simplecov-summary'

SimpleCov.minimum_coverage 100

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::SummaryFormatter
]

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'

  add_group  'Everything', '/lib/teachable_mock/'
end
