# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tradeking/version'

Gem::Specification.new do |spec|
  spec.name          = "tradeking"
  spec.version       = TradeKing::VERSION
  spec.authors       = ["Ty Rauber"]
  spec.email         = ["tyrauber@mac.com"]
  spec.description   = %q{TradeKing Api Ruby Gem}
  spec.summary       = %q{A ruby gem leveraging the TradeKing API to enable development of fully featured trading and analytical applications.}
  spec.homepage      = "https://github.com/tyrauber/tradeking"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'oauth'
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "hpricot"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fakeweb'
  spec.add_development_dependency 'vcr'
end
