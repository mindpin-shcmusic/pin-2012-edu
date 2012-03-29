class Tagging < BuildDatabaseAbstract
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :model, :polymorphic => true
  belongs_to :tag
  
  validates :tag, :creator, :model, :presence => true

=begin
  def add_tagging(creator, tag_name)
    tag = Tag.get(tag_name)
    Tagging.create(:creator_id => creator.id, :tag_id => tag.id)
  end
=end
  
  def remove_tagging_by_each(model_type, model_id, tag_name)
    tag = Tag.get(tag_name)
    tagging = Tagging.where(:model_type => model_type, :model_id => model_id, :tag_id => tag.id).first
    tagging.destroy if !tagging.blank?
  end
  
  def remove_tagging_by_model(model_type, model_id)
    tagging = Tagging.where(:model_type => model_type, :model_id => model_id)
    tagging.destroy_all if !tagging.blank?
  end
  
  
  module TaggableMethods
    def self.included(base)
      base.has_many :taggings,:as=>:model
      base.has_many :tags, :through=>:taggings
      base.send(:include,InstanceMethods)
    end
    module InstanceMethods
      def add_tag(user, name)
        if name.include?(",")
          errors.add(:base, '只能填入一个标签')
          return false
        end
        
        tag = Tag.get(name)
        tagging = self.taggings.where(:tag_id=>tag.id).first
        if tagging.blank?
          self.taggings.create(:tag=>tag,:creator=>user)
        end
        tag
      end
      
      def remove_tag(name)
        tag = Tag.where(:name=>name).first
        if !tag.blank?
          tagging = self.taggings.where(:tag_id=>tag.id).first
          tagging.destroy if !tagging.blank?
        end
        tag
      end
      
    end
  end
end
