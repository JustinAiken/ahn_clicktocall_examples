class ClickToCallController < ApplicationController

  def index
    @all_calls = Call.all
    @call = Call.new(first_num: "user/usera", second_num: "user/userb")
  end

  def create
    @call = Call.new params[:call]
    if @call.save
      redirect_to :click_to_call_index, notice: "Call started..."
    else
      flash[:error] = @call.errors
      redirect_to :click_to_call_index
    end
  end

  def destroy
    @call = Call.find_by_id params[:id]
    @call.hangup!
    redirect_to :click_to_call_index
  end
end
