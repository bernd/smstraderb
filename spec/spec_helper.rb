$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'rspec'
require 'rspec/autorun'
require 'rack/test'
require 'artifice'

RSpec.configure do |config|
  include Rack::Test::Methods
end
