# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drama_queen/version'

Gem::Specification.new do |spec|
  spec.name          = 'drama_queen'
  spec.version       = DramaQueen::VERSION
  spec.author        = 'Steve Loveless'
  spec.email         = 'steve.loveless@gmail.com'
  spec.description   = %q{A simple, non-threaded, local-object pub-sub/observer
with the ability to pub-sub on topics.  Topics can be any Ruby object.}
  spec.summary       = spec.description
  spec.homepage      = 'https://githb.com/turboladen/drama_queen'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0.beta1'
end
