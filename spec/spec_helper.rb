# frozen_string_literal: true

require_relative 'setup/simplecov'

require 'teachable_mock'

RSpec.configure do |config|
  Kernel.srand config.seed

  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
