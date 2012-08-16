class CategoriesController < ApplicationController
  before_filter :login_required

  def lazyload_sub_dynatree
    category = Category.find(params[:id])
    render :json => category.lazyload_sub_dynatree
  end
end
  