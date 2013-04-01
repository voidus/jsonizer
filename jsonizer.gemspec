# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonizer/version'
require 'rake'

Gem::Specification.new do |gem|
  gem.name          = "jsonizer"
  gem.version       = Jsonizer::VERSION
  gem.authors       = ["Simon Kohlmeyer"]
  gem.email         = ["simon.kohlmeyer@gmail.com"]
  gem.summary       = 'Module to easily provide json serialization'
  gem.description   = <<HERE
#{gem.summary}
Structurally inspired by http://github.com/dkubb/equalizer
HERE
  gem.homepage      = "http://github.com/voidus/jsonizer"
  gem.license       = "MIT"

  gem.files         = FileList['lib/**/*.rb', 'spec/**/*', '[A-Z]*'].to_a
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'json'

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "equalizer"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"
end
