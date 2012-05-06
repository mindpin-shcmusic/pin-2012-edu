class Comment < BuildDatabaseAbstract
  belongs_to :model,
             :polymorphic => true

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  belongs_to :reply_comment,
             :class_name  => 'Comment',
             :foreign_key => 'reply_comment_id'

  belongs_to :reply_user,
             :class_name  => 'User',
             :foreign_key => 'reply_comment_user_id'
  
  validates :content,
            :presence => true

  validates :reply_comment_user_id, 
            :presence => {
              :if => Proc.new do |comment|
                !comment.reply_comment_id.blank?
              end
            }
    
  before_validation :set_reply_comment_user_id,
                    :on => :create

  def set_reply_comment_user_id
    if !self.reply_comment_id.blank?
      self.reply_comment_user_id = reply_comment.creator_id
    end
  end
  
  module CommentableMethods
    def self.included(base)
      base.has_many :comments,
                    :as => :model
    end
  end
  
end
