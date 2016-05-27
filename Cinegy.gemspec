# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Cinegy/version'

Gem::Specification.new do |spec|
  spec.name          = "Cinegy"
  spec.version       = Cinegy::VERSION
  spec.authors       = ["Marcello Romani"]
  spec.email         = ["illello107@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/lello107/Cinegy-Gem.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = " Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_dependency "bindata"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "nokogiri-happymapper", "~> 0.5"
  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "uuidtools", "~> 2.1"
  spec.add_dependency "streamio-ffmpeg"#, git: "git://github.com/lello107/streamio-ffmpeg.git"
  

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
