# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'controlar/version'

Gem::Specification.new do |spec|
  spec.name          = "controlar"
  spec.version       = Controlar::VERSION
  spec.authors       = ["Marie Markwell"]
  spec.email         = ["me@marie.so"]
  spec.description   = %q{Voice control for Linux}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/duckinator/controlar"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'festivaltts4r'
  spec.add_runtime_dependency 'chronic'
  spec.add_runtime_dependency 'timers', '~> 4.0'
  spec.add_runtime_dependency 'default'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', "~> 3.1"
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'simplecov'
end
