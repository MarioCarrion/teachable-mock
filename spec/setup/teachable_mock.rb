# frozen_string_literal: true

Teachable::Mock.setup do |config|
  config.hostname     = 'https://fast-bayou-75985.herokuapp.com/'
  config.open_timeout = 15
  config.read_timeout = 15
end
