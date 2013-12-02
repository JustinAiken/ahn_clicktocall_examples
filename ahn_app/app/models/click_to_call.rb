class ClickToCall

  @@calls = {}

  attr_accessor :first_num, :second_num, :id

  def initialize(first_num, second_num, id)
    @first_num  = first_num
    @second_num = second_num
    @id         = id
    @status     = :not_started
    @@calls[id] = self
  end

  def start!
    @ahn_call = Adhearsion::OutboundCall.originate first_num,
      from:                "8675309",
      controller:          ClickToCallController,
      controller_metadata: {second_num: second_num}
  end

  def status
    if @ahn_call
      @ahn_call.active? ? :active : :ended
    else
      :ended
    end
  end

  def ahn_call
    @ahn_call
  end

  def hangup!
    @ahn_call.hangup
  end

  def self.calls
    @@calls
  end

  def self.find(id)
    @@calls[id]
  end

  def self.test
    ClickToCall.new("user/usera", "user/userb", "foo").start!
  end
end
