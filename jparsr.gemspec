# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jparsr/version'

Gem::Specification.new do |spec|
  spec.name          = "jparsr"
  spec.version       = JParsr::VERSION
  spec.authors       = ["okke"]
  spec.email         = ["oftewel@gmail.com"]
  spec.summary       = %q{Java parsing library}
  spec.description   = %q{Java source code parsing stuff"}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["jparsr"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'parslet'
end
