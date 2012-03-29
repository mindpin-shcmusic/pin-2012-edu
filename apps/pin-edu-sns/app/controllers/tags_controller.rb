class TagsController < ApplicationController
  # 判断当前是哪个model
  def determine_model(model_type, model_id)
    model_type = model_type.downcase
    case model_type
    when "vote"
      Vote.find(params[:model_id]) if params[:model_id]
    when "question"
      Question.find(params[:model_id]) if params[:model_id]
    else
      return false
    end
  end
  private :determine_model
  
  def add_tag
    @current_model = determine_model(params[:model_type], params[:model_id])

    @current_model.add_tag(current_user, params[:name])
    
    redirect_to @current_model
  end

  def update_tags
    tags_str = params[:tags_str]
    tags = tags_str.split(",")
    
    # 先删除旧的标签关联记录
    tagging = Tagging.new
    tagging.remove_tagging_by_model(params[:model_type], params[:model_id])
    
    @current_model = determine_model(params[:model_type], params[:model_id])
    tags.each do |tag|
      tag = tag.strip
      
      @current_model.add_tag(current_user, tag)
      
      tagging = Tagging.new
      tagging.add_tagging(current_user, tag)
    end
    
    redirect_to @current_model
  end
  
  def remove_tag
    @current_model = determine_model(params[:model_type], params[:model_id])
    
    tagging = Tagging.new
    tagging.remove_tagging_by_each(params[:model_type], params[:model_id], params[:tag])
    redirect_to @current_model
  end
  
  def create_tag
  end
  
  def edit_tags
 
  end

end
