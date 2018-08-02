Gem::Specification.new do |s|
  s.name          = 'pagemaster'
  s.version       = '2.1.0'
  s.date          = '2018-03-27'
  s.summary       = 'jekyll pagemaster plugin'
  s.description   = 'jekyll plugin for generating md pages from csv/json/yml'
  s.authors       = ['Marii Nyrop']
  s.files         = ['lib/pagemaster.rb']
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/mnyrop/pagemaster'
  s.license       = 'MIT'

  s.add_dependency 'jekyll', '~> 3.8'

  s.add_development_dependency 'bundler', '~> 1.16'
  s.add_development_dependency 'faker', '~> 1.9'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '>= 0.5'
end
