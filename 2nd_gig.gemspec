# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require '2nd_gig/version'

Gem::Specification.new do |spec|
  spec.name          = '2nd_gig'
  spec.version       = SecondGig::VERSION
  spec.authors       = ['Tomohiro, TAIRA']
  spec.email         = ['tomohiro.t@gmail.com']
  spec.description   = 'Alternative GitHub IRC Gateway'
  spec.summary       = 'Alternative GitHub IRC Gateway'
  spec.homepage      = 'https://github.com/Tomohiro/2nd_gig'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'net-irc'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'slop'
end
