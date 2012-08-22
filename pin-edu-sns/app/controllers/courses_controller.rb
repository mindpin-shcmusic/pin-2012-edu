class CoursesController < ApplicationController
  before_filter :per_load
  def per_load
    @course  = Course.find params[:id] if params[:id]
  end


  def index
    @courses = Course.paginated(params[:page])
  end

  def mine
    @courses = current_user.courses.paginated(params[:page])
  end

  def show
  end

end
