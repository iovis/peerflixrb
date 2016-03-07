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
  spec.homepage      = 'https://github.com/iovis9/peerflixrb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'addic7ed', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
  spec.add_development_dependency 'factory_girl', '~> 4.5'
  spec.add_development_dependency 'webmock', '~> 1.24'
  spec.add_development_dependency 'pry', '~> 0.10'
end
