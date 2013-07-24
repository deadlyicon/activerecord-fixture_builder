# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/fixture_builder/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-fixture_builder"
  spec.version       = ActiveRecord::FixtureBuilder::VERSION
  spec.authors       = ["Jared Grippe"]
  spec.email         = ["jared@deadlyicon.com"]
  spec.description   = %q{A simple fixture builder for active record}
  spec.summary       = %q{A simple fixture builder for active record}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
