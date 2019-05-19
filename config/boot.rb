require 'bundler/setup'

require 'rest-client'
require 'sinatra'
require 'singleton'

Dir["#{File.expand_path('../lib', __dir__)}/*.rb"].each { |file| require file }
