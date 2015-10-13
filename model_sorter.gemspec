# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'model_sorter/version'

Gem::Specification.new do |spec|
  spec.name          = "model_sorter"
  spec.version       = ModelSorter::VERSION
  spec.authors       = ["Scott1743"]
  spec.email         = ["512981271@qq.com"]
  spec.summary       = ""
  spec.description   = %q{To sort the instance of ActiveRecord::Relation by Redis}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'redis-objects', '~> 1.2.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1"

end
