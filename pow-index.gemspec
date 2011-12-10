# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pow-index/version"

Gem::Specification.new do |s|
  s.name        = "pow-index"
  s.version     = PowIndex::VERSION
  s.authors     = ["marutanm"]
  s.email       = ["marutanm@gmail.com"]
  s.homepage    = "http://github.com/marutanm/pow-index"
  s.summary     = "Create index page of 37signals-Pow"
  s.description = "Create index page of 37signals-Pow"

  s.rubyforge_project = "pow-index"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("sinatra", [">= 1.2.0"])
  s.add_runtime_dependency("haml", [">= 3.1.0"])
  s.add_development_dependency("shoulda", [">= 0"])
  s.add_development_dependency("rack-test", ["~> 0.6.1"])
  s.add_development_dependency("rake", [">= 0.9.2.2"])

end
