# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capybara/maleficent/version"

Gem::Specification.new do |spec|
  spec.name          = "capybara-maleficent"
  spec.version       = Capybara::Maleficent::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]

  spec.summary       = %q{Wrap your Capybara matchers with sleep intervals to reduce fragility of specs.}
  spec.description   = %q{Wrap your Capybara matchers with sleep intervals to reduce fragility of specs.}
  spec.homepage      = "https://github.com/jeremyf/capybara-maleficent"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version      = '>= 2.2.2'

  spec.add_dependency "activesupport", ">= 4.2.0"
  spec.add_dependency "capybara", ">= 2.13", "< 4.0"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "rspec", "~> 3.0"
end
