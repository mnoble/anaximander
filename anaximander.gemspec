# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anaximander/version'

Gem::Specification.new do |spec|
  spec.name          = "anaximander"
  spec.version       = Anaximander::VERSION
  spec.authors       = ["Matte Noble"]
  spec.email         = ["me@mattenoble.com"]
  spec.summary       = %q{Web scraper that collects assets and links.}
  spec.description   = %q{Web scraper that collects assets and links.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "colorize"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-autotest"
  spec.add_development_dependency "fakeout"
end
