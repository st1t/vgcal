# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vgcal/version"

Gem::Specification.new do |spec|
  spec.name          = "vgcal"
  spec.version       = Vgcal::VERSION
  spec.authors       = ["Shota Ito"]
  spec.email         = ["shota.ito.jp@gmail.com"]

  spec.summary       = "%q{The vgcal command simplifies the display of Google Calendar events.}"
  spec.description   = "%q{The vgcal command simplifies the display of Google Calendar events.}"
  spec.homepage      = "https://github.com/st1t/vgcal"
  spec.license     = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2")
  spec.metadata['rubygems_mfa_required'] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"

  spec.add_runtime_dependency "thor", "~> 1.1"
  spec.add_runtime_dependency "google-apis-calendar_v3"
  spec.add_runtime_dependency "googleauth"
  spec.add_runtime_dependency "dotenv"
end
