class RedisCallLoop < Adhearsion::Plugin
  include Celluloid
  include Singleton

  config :redis_call_loop do
    interval 1, desc: "Time (in seconds) to sleep between checking for a new c2c"
  end

  init :redis_call_loop, after: :lemondrop do
    self.boot
  end

  def initialize
    every(RedisCallLoop.interval) { RedisCallLoop.run }
  end

  def self.boot
    RedisCallLoop.supervise_as :the_loop
  end

  def self.run
    if call_request = Lemondrop.lpop(:make_call)
      params = JSON.parse(call_request)
      make_call! params
    end

    if hangup_request = Lemondrop.lpop(:end_call)
      params = JSON.parse(hangup_request)
      end_call! params
    end
  end

  def self.make_call!(params)
    c2c = ClickToCall.new params['first_num'], params['second_num'], params['id']
    c2c.start!
  end

  def self.end_call!(params)
    c2c = ClickToCall.find params['id']
    c2c.hangup!
  end

  def self.interval
    config.interval
  end
end
