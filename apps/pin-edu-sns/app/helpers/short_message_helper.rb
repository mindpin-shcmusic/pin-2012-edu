module ShortMessageHelper
  
  class MessageListGroup
    
    attr_reader :sender, :messages
    
    def initialize(sender)
      @sender = sender
      @messages = []
    end
    
    def add_message(message)
      @messages << message
    end
    
  end
  
  def split_messages_group(messages)
    re = []
    
    last_sender = nil
    
    messages.each do |message|
      sender = message.sender
      
      if sender != last_sender
        group = MessageListGroup.new(sender)
        group.add_message(message)
        re << group
      else
        group = re.last
        group.add_message(message)
      end
      
      last_sender = sender
    end
    
    return re
    
  end
  
end