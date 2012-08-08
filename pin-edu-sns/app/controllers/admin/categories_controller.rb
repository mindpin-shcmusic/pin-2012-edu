class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  
  def index
    @level1_categories = Category.roots
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])

    if params[:parent_id].blank?
      @category.save
    else
      @category.save_as_child_of(Category.find(params[:parent_id]))
    end
    if @category.id.blank?
      error = @category.errors.first
      flash[:error] = error[1]
      return redirect_to "/admin/categories/new"
    end
    redirect_to "/admin/categories"
  end

  def destroy
    Category.find(params[:id]).remove
    redirect_to :action => :index
  end
  
end
