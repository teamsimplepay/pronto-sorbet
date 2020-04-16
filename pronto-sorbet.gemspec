
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pronto/sorbet/version"

Gem::Specification.new do |spec|
  spec.name          = "pronto-sorbet"
  spec.version       = Pronto::Sorbet::VERSION
  spec.authors       = ["Ashish Kulkarni"]
  spec.email         = ["opensource@simplepay.cloud"]

  spec.summary       = "Pronto runner for Sorbet, a static type checker for Ruby"
  spec.homepage      = "https://github.com/teamsimplepay/pronto-sorbet"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_runtime_dependency('pronto', '~> 0.10.0')
  spec.add_runtime_dependency('sorbet', '~> 0.5.0')

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
end
