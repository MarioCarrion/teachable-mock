# frozen_string_literal: true

VCR.configure do |config|
  root_path = File.expand_path('../../..', __FILE__)

  config.configure_rspec_metadata!
  config.cassette_library_dir = File.join(root_path, 'spec', 'cassettes')
  config.hook_into :webmock
end
