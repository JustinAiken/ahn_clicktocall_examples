ENV["AHN_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'adhearsion/rspec'
require 'rspec/autorun'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
