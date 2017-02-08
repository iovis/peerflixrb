# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peerflixrb/version'

Gem::Specification.new do |spec|
  spec.name          = 'peerflixrb'
  spec.version       = Peerflixrb::VERSION
  spec.authors       = ['David Marchante']
  spec.email         = ['davidmarchan@gmail.com']

  spec.summary       = 'Wrapper for peerflix with automatic search through KickAss Torrents, Yifysubtitles and Addic7ed.'
  spec.description   = %q{With peerflixrb you can search for movies and TV shows and stream them directly on your favorite video player! You can choose the torrent and the subtitles file or you can let it choose the best for you.}
  spec.homepage      = 'https://github.com/iovis9/peerflixrb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = 'peerflixrb'
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'addic7ed_downloader', '~> 1.0'
  spec.add_runtime_dependency 'tpb_search'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'highline', '~> 1.7'
  spec.add_runtime_dependency 'httparty', '~> 0.13'
  spec.add_runtime_dependency 'rubyzip', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-byebug', '~> 3.4'
end
