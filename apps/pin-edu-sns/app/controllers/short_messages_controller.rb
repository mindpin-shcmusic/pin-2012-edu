class ShortMessagesController < ApplicationController
  def inbox
    @messages = current_user.received_messages
  end

  def outbox
    @messages = current_user.sent_messages
  end

  def new
    @message = ShortMessage.new :receiver_id => params[:receiver_id]
  end

  def create
    @message = current_user.sent_messages.build params[:short_message]

    if @message.save
      redirect_to :action => :inbox
    else
      render :status => 406,
             :text   => 'oh no!'
    end
  end

  def read
    @message = ShortMessage.find params[:id]
    @message.read!

    render :text => 'ok'
  end

  def destroy
    @message = ShortMessage.find params[:id]

    case params[:sender]
    when 'true'
      @message.sender_hide!
      redirect_to :action => :outbox
    when 'false'
      @message.receiver_hide!
      redirect_to :action => :inbox
    end
  end
end
