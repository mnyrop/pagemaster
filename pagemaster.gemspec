# frozen_string_literal: true

$LOAD_PATH.push File.expand_path 'lib'
require 'pagemaster/version'

Gem::Specification.new do |spec|
  spec.name          = 'pagemaster'
  spec.version       = Pagemaster::VERSION
  spec.date          = '2018-03-27'
  spec.summary       = 'jekyll pagemaster plugin'
  spec.description   = 'jekyll plugin for generating md pages from csv/json/yml'
  spec.authors       = ['Marii Nyrop']
  spec.homepage      = 'https://github.com/mnyrop/pagemaster'
  spec.license       = 'MIT'

  spec.files                  = Dir['Gemfile', 'lib/**/*']
  spec.test_files             = Dir['spec/*']
  spec.require_paths          = ['lib']
  spec.required_ruby_version  = '>= 2.4'

  spec.add_runtime_dependency 'jekyll', '~> 4'
  spec.add_runtime_dependency 'rainbow', '~> 3.0'
  spec.add_runtime_dependency 'safe_yaml', '~> 1.0'

  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '>= 0.5'
end
