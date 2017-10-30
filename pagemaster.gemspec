# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'pagemaster'
  s.version     = '1.0.0'
  s.platform    = Gem::Platform::RUBY
  s.date        = '2017-10-30'
  s.summary     = 'jekyll pagemaster plugin'
  s.description = 'jekyll .md page generator plugin from csv or yaml files'
  s.authors     = ['Marii Nyröp']
  s.files       = ['lib/pagemaster.rb']
  s.require_path   = 'lib'
  s.homepage    = 'https://github.com/mnyrop/pagemaster'
  s.license     = 'MIT'

  s.add_dependency 'jekyll', '~> 3.0'
end
