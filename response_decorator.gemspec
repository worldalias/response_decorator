# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'response_decorator/version'

Gem::Specification.new do |spec|
  spec.name          = "response_decorator"
  spec.version       = ResponseDecorator::VERSION
  spec.authors       = ["Dmitriy Bielorusov"]
  spec.email         = ["d.belorusov@gmail.com"]
  spec.summary       = %q{Response decorator for customizing ActiveModelSerializer}
  spec.description   = %q{Customize response for AR, Mongoid, Array onjects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'
  spec.add_dependency 'active_model_serializers'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
