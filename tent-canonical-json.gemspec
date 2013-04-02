# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tent-canonical-json/version'

Gem::Specification.new do |gem|
  gem.name          = "tent-canonical-json"
  gem.version       = TentCanonicalJson::VERSION
  gem.authors       = ["Jesse Stuart"]
  gem.email         = ["jesse@jessestuart.ca"]
  gem.description   = %q{Derive Tent canonical json from post}
  gem.summary       = %q{Derive Tent canonical json from post}
  gem.homepage      = "https://github.com/tent/tent-canonical-json-ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "json-pointer"
  gem.add_runtime_dependency "yajl-ruby"

  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'rake'
end
