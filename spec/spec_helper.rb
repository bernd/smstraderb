$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'rack/test'
require 'artifice'

Spec::Runner.configure do |config|
  include Rack::Test::Methods
end
