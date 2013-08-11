require 'rubygems'
require 'bundler/setup'
require 'vcr_setup'
require 'api_keys'
require 'tradeking'
require 'tzinfo'

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end