require 'minitest/autorun'
require 'minitest/spec'

$:.unshift File.expand_path('../lib', __FILE__)

require 'minitest/reporters'
MiniTest::Reporters.use!
