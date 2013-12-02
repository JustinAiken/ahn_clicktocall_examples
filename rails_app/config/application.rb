require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

module RailsApp
  class Application < Rails::Application

    config.autoload_path = %W(#{config.root}/lib)
  end
end
