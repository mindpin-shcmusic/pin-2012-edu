class CategoriesController < ApplicationController
  before_filter :login_required
  
  def index
    @categories = Category.roots
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save_as_child_of(Category.find(params[:parent_id]))
      return redirect_to "/categories"
    end
    error = @category.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/categories/new"
  end
end
