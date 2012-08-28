# -*- encoding: utf-8 -*-
require File.expand_path('../lib/trlo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vincent Siebert"]
  gem.email         = ["vincent@siebert.im"]
  gem.description   = %q{Trello comman line tool}
  gem.summary       = %q{Trello comman line tool}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "trlo"
  gem.require_paths = ["lib"]
  gem.version       = Trlo::VERSION
  gem.platform      = Gem::Platform::RUBY

  gem.add_dependency "ruby-trello"
  gem.add_dependency "hirb"
  gem.add_dependency "colored"
  gem.add_dependency "highline"

  gem.add_development_dependency "pry"
end
