# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jibbajabba/version'

Gem::Specification.new do |spec|
  spec.name          = 'jibbajabba'
  spec.version       = JibbaJabba::VERSION
  spec.authors       = ['Nathaniel Wroblewski']
  spec.email         = ['NathanielWroblewski@gmail.com']
  spec.summary       = %q{Fluent Ruby API wrapper for the HipChat API}
  spec.description   = %q{Fluent Ruby API wrapper for the HipChat API}
  spec.homepage      = 'https://github.com/NathanielWroblewski/jibbajabba'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-mocks'
end
