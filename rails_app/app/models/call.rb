require 'ami'

class Call
  include ActiveModel::Model

  @@calls = {}

  attr_accessor :first_num, :second_num, :ahn_method ,:id

  def save
    self.id = SecureRandom.uuid
    @@calls[self.id] = self

    initiate_call!
  end

  def initiate_call!
    self.send "dial_with_#{ahn_method}"
  end

  def hangup!
    self.send "hangup_with_#{ahn_method}!"
    @@calls.delete self.id
  end

  def status
    return "Ended" unless @@calls[self.id]
    status = self.send "status_with_#{ahn_method}"
    @@calls.delete self.id unless status.to_sym == :active

    status
  end

  def dial_with_drb
    AMI.c2c_start! first_num, second_num, id
  end

  def dial_with_http
    HTTParty.post "http://#{HTTP_HOST}:#{HTTP_PORT}/call?first_num=#{first_num}&second_num=#{second_num}&id=#{id}"
  end

  def dial_with_redis
    redis.rpush :make_call, redis_request
  end

  def hangup_with_drb!
    AMI.c2c_hangup! id
  end

  def hangup_with_http!
    HTTParty.post "http://#{HTTP_HOST}:#{HTTP_PORT}/hangup?id=#{id}"
  end

  def hangup_with_redis!
    redis.rpush :end_call, redis_request
  end

  def status_with_drb
    AMI.c2c_status id
  end

  def status_with_http
    response = HTTParty.get "http://#{HTTP_HOST}:#{HTTP_PORT}/status?id=#{id}"
    response.body
  end

  def status_with_redis
    # Left as an exercise for the reader
    :active
  end

  def redis
    @@redis ||= Redis.new host: REDIS_HOST, port: REDIS_PORT
  end

  def redis_request
    {first_num: first_num, second_num: second_num, id: id}.to_json
  end

  class << self
    def all
      @@calls
    end

    def find_by_id(id)
      @@calls[id]
    end
  end
end
