require 'reel'

class RequestHandler
  def initialize(host, port)
    Reel::Server.supervise(host, port) do |connection|
      connection.each_request do |request|

        params = CGI::parse request.query_string

        case request.url
        when /call/
          c2c_start! params["first_num"][0], params["second_num"][0], params["id"][0]
          request.respond :ok, "200 OK"
        when /status/
          status = c2c_status(params["id"][0]) rescue :ended
          request.respond :ok, String(status)
        when /hangup/
          c2c_hangup! params["id"][0]
          request.respond :ok, "200 OK"
        end
      end
    end
  end

  def c2c_start!(num1, num2, id)
    ClickToCall.new(num1, num2, id).start!
  end

  def c2c_status(id)
    ClickToCall.find(id).status
  end

  def c2c_hangup!(id)
    ClickToCall.find(id).hangup!
  end
end
