# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peerflixrb/version'

Gem::Specification.new do |spec|
  spec.name          = 'peerflixrb'
  spec.version       = Peerflixrb::VERSION
  spec.authors       = ['David Marchante']
  spec.email         = ['davidmarchan@gmail.com']

  spec.summary       = 'Wrapper for peerflix with automatic search through KAT and Addic7ed.'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'addic7ed'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'factory_girl'  # needed?
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
end
