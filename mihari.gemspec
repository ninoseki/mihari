# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mihari/version"

Gem::Specification.new do |spec|
  spec.name          = "mihari"
  spec.version       = Mihari::VERSION
  spec.authors       = ["Manabu Niseki"]
  spec.email         = ["manabu.niseki@gmail.com"]

  spec.summary       = "A framework for continuous malicious hosts monitoring."
  spec.description   = "A framework for continuous malicious hosts monitoring."
  spec.homepage      = "https://github.com/ninoseki/mihari"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "vcr", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 3.6"

  spec.add_dependency "addressable", "~> 2.6"
  spec.add_dependency "censu", "~> 0.2"
  spec.add_dependency "email_address", "~> 0.1"
  spec.add_dependency "hachi", "~> 0.2"
  spec.add_dependency "mem", "~> 0.1"
  spec.add_dependency "net-ping", "~> 2.0"
  spec.add_dependency "onyphe", "~> 0.2"
  spec.add_dependency "public_suffix", "~> 3.1"
  spec.add_dependency "shodanx", "~> 0.1"
  spec.add_dependency "slack-notifier", "~> 2.3"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "urlscan", "~> 0.2"
  spec.add_dependency "virustotalx", "~> 0.1"
end
