# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/shin/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-shin"
  spec.version       = Guard::ShinVersion::VERSION
  spec.authors       = ["Amos Wenger"]
  spec.email         = ["amos@memoways.com"]
  spec.summary       = %q{Recompile Shin code easily.}
  spec.description   = %q{Recompile ClojureScript code using the Shin compiler easily.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "guard", ">= 2.0.0"
  spec.add_dependency "shin"
end
