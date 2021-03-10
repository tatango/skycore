# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skycore/version'

Gem::Specification.new do |spec|
  spec.name          = "skycore"
  spec.version       = Skycore::VERSION
  spec.authors       = ["Seva Rybakov"]
  spec.email         = ["jumpincode@gmail.com"]

  spec.summary       = %q{Skycore HTTP wrapper}
  spec.description   = %q{Brought to you by tatango}
  spec.homepage      = "https://github.com/tatango/skycore"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.18"
  spec.add_dependency "crack", "~> 0.4" # Pretty dope
  spec.add_dependency "builder" # RIP, Jim

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "byebug", "~> 11.1"
  spec.add_development_dependency "executable-hooks", "~> 1.6"
  spec.add_development_dependency "gem-wrappers", "~> 1.4"
end
