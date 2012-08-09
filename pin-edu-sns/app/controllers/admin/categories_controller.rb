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

    @category.save
    if !params[:parent_id].blank?
      @category.move_to_child_of(Category.find(params[:parent_id]))
    end
    if @category.id.blank?
      error = @category.errors.first
      flash[:error] = error[1]
      return redirect_to "/admin/categories/new"
    end
    redirect_to "/admin/categories"
  end

  # for ajax
  def destroy
    Category.find(params[:id]).remove
    render :text => 'ok'
  end
  
  def import_from_yaml_page
  end

  def import_from_yaml
    Category.import_from_yaml(params[:yaml_file])
    redirect_to "/admin/categories"
  rescue Exception=>ex
    puts ex.message
    puts ex.backtrace*"\n"
    flash[:error] = "YAML 文件格式有错误"
    redirect_to "/admin/categories/import_from_yaml_page"
  end

end
