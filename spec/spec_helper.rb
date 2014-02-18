require 'coveralls'
Coveralls.wear!

require 'simplecov'

SimpleCov.configure do
  add_filter 'spec/'
end
SimpleCov.start unless ENV['TRAVIS']

require 'bundler/setup'

require 'rspec'

