root_path = File.expand_path File.dirname('../')

Dir["#{root_path}/app/classes/*.rb"].each { |class_rb| require class_rb }
Dir["#{root_path}/app/models/*.rb"].each  { |model_rb| require model_rb }
Dir["#{root_path}/app/call_controllers/*.rb"].each { |controller| require controller }

Adhearsion.config do |config|
  config.platform.environment   = 'development'
  config.platform.logging.level = :info

  config.punchblock.certs_directory = 'certs'
  config.punchblock.username = 'usera@10.203.176.3'
  config.punchblock.password = '1'

  ##
  # DRB Settings
  config.adhearsion_drb.host          = "0.0.0.0"
  config.adhearsion_drb.acl.allow     = ["all"]
  config.adhearsion_drb.shared_object = AMI.new

  ##
  # HTTP Settings
  config.virginia.host    = "0.0.0.0"
  config.virginia.port    = 8080
  config.virginia.handler = RequestHandler

  ##
  # Redis Settings
  config.lemondrop.uri = "redis://10.203.176.3:6379"
end

Adhearsion.router do
end

Adhearsion::Events.draw do
end
