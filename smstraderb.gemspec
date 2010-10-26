# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "smstraderb/constants"

Gem::Specification.new do |s|
  s.name        = 'smstraderb'
  s.version     = SMSTradeRB::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Bernd Ahlers']
  s.email       = ['bernd@tuneafish.de']
  s.homepage    = 'http://rubygems.org/gems/smstraderb'
  s.summary     = %q{client library for the smstrade.de HTTP API}
  s.description = %q{smstraderb provides a client library for the smstrade.de HTTP API.}

  #s.rubyforge_project = "smstraderb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.0.0'
  s.add_development_dependency 'artifice'
  s.add_development_dependency 'rack-test'
end
