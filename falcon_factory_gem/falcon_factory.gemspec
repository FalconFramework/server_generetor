# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'falcon_factory/version'

Gem::Specification.new do |spec|

  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'falcon_factory'
  spec.version     = FalconFactory::VERSION
  spec.summary     = 'Backend web application framework.'
  spec.description = 'Will generate backend for you through a DB model.'

  spec.authors       = ["thiagotmb"]
  spec.email         = ["tmb0710@gmail.com"]
  spec.license       = "MIT"
  spec.required_ruby_version     = '>= 2.3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["falcon_factory"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport-inflector"
  spec.add_dependency "activesupport", "~> 5.0.0.rc1"
  spec.add_dependency "bundler", "~> 1.11"

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "rake", "~> 10.0"

  spec.post_install_message = "Thanks for install falcon_factory!"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.3.0 or newer is required to protect against public gem pushes."
  end

end
