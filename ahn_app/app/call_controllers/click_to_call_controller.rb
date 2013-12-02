class ClickToCallController < Adhearsion::CallController

  def run
    answer
    dial next_number
    hangup
  end

private

  def next_number
    metadata[:second_num]
  end
end
