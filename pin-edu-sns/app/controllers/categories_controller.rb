class CategoriesController < ApplicationController
  before_filter :login_required

  def lazyload_sub_dynatree
    render :json => Category.lazyload_sub_dynatree(params[:id])
  end
end
