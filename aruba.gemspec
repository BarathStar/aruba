# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'aruba'
  s.version     = '0.6.2'
  s.authors     = ['David Chelimsky', 'Jarl Friis', 'Dennis Günnewig', 'Aslak Hellesøy', 'Mike Sassak', 'Matt Wynne']
  s.description = 'Extend your test framework - e.g. Cucumber, RSpec - to make testing of CLI-applications easier'
  s.summary     = "aruba-#{s.version}"
  s.license     = 'MIT'
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'http://github.com/cucumber/aruba'

  s.add_runtime_dependency 'cucumber', '~> 2.0'
  s.add_runtime_dependency 'childprocess', '~> 0.5.6'
  s.add_runtime_dependency 'rspec-expectations', '~> 3.2.1'
  s.add_runtime_dependency 'kramdown', '~> 1.7.0'

  s.add_development_dependency 'bundler', '~> 1.9.6'

  s.rubygems_version = ">= 1.6.1"
  # s.required_ruby_version = '>= 2.0'
  s.post_install_message = 'From aruba > 1.0 ruby 1.9.3-support is discontinued'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| ::File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.rdoc_options  = ["--charset=UTF-8"]

  s.require_paths = ['lib']
end
