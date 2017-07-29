# frozen_string_literal: true

lib = File.expand_path(File.join('..', 'lib'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'teachable_mock/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '~> 2.3'

  s.name         = 'teachable_mock'
  s.version      = Teachable::Mock::Version::VERSION
  s.date         = Teachable::Mock::Version::DATE

  s.summary      = 'Teachable Mock API Wrapper'
  s.description  = 'Wrapper for Teachable Mock API'
  s.authors      = 'Mario Carrion'
  s.email        = 'info@carrion.ws'
  s.homepage     = 'https://github.com/MarioCarrion/teachable-mock'
  s.licenses     = ['MIT']
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {spec,test}`.split("\n")
  s.require_path = 'lib'

  s.add_development_dependency 'pry',               '~> 0.10', '>= 0.10.4'
  s.add_development_dependency 'pry-nav',           '~> 0.2',  '>= 0.2.4'
  s.add_development_dependency 'rspec',             '~> 3.6',  '>= 3.6.0'
  s.add_development_dependency 'rubocop',           '~> 0.49', '>= 0.49.1'
  s.add_development_dependency 'rubocop-rspec',     '~> 1.5',  '>= 1.15.1'
  s.add_development_dependency 'simplecov',         '~> 0.14', '>= 0.14.1'
  s.add_development_dependency 'simplecov-rcov',    '~> 0.2',  '>= 0.2.3'
  s.add_development_dependency 'simplecov-summary', '~> 0.0',  '>= 0.0.5'
  s.add_development_dependency 'vcr',               '~> 3.0',  '>= 3.0.3'
  s.add_development_dependency 'webmock',           '~> 3.0',  '>= 3.0.1'
end
