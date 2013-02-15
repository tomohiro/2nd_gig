# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require '2nd_gig/version'

Gem::Specification.new do |gem|
  gem.name          = '2nd_gig'
  gem.version       = SecondGig::VERSION
  gem.authors       = ['Tomohiro, TAIRA']
  gem.email         = ['tomohiro.t@gmail.com']
  gem.description   = 'Alternative GitHub IRC Gateway'
  gem.summary       = 'Alternative GitHub IRC Gateway'
  gem.homepage      = 'https://github.com/Tomohiro/2nd_gig'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'net-irc'
  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'slop'
end
