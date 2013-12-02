require 'drb'
require 'singleton'

class AMI
  include Singleton

  attr_accessor :drb

  def initialize
    @drb = DRbObject.new_with_uri "druby://#{DRB_HOST}:#{DRB_PORT}"
  end

  def method_missing(method_name, *args, &block)
    @drb.send method_name, *args, &block
  end

  def self.method_missing(method_name, *args, &block)
    instance.send method_name, *args, &block
  end
end
