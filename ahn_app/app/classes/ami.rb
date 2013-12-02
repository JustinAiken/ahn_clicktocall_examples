class AMI

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
