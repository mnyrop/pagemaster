# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagemaster/version'

Gem::Specification.new do |spec|
  spec.name          = 'pagemaster'
  spec.version       = Pagemaster::VERSION
  spec.date          = '2018-03-27'
  spec.summary       = 'jekyll pagemaster plugin'
  spec.description   = 'jekyll plugin for generating md pages from csv/json/yml'
  spec.authors       = ['Marii Nyrop']
  spec.files         = ['lib/pagemaster.rb']
  spec.require_path  = 'lib'
  spec.homepage      = 'https://github.com/mnyrop/pagemaster'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.4'

  spec.add_runtime_dependency 'jekyll', '~> 4'
  spec.add_runtime_dependency 'rainbow', '~> 3.0'
  spec.add_runtime_dependency 'safe_yaml', '~> 1.0'

  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '>= 0.5'
end
