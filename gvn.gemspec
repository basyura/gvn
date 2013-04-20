# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gvn/version'

Gem::Specification.new do |spec|
  spec.name          = "gvn"
  spec.version       = Gvn::VERSION
  spec.authors       = ["basyura"]
  spec.email         = ["basyura@gmail.com"]
  spec.description   = %q{svn wrapper like git}
  spec.summary       = %q{svn wrapper like git}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
