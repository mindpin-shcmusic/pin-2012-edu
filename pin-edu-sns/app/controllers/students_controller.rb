# -*- coding: utf-8 -*-
class StudentsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
  end


  def index
    return redirect_to '/dashboard' if current_user.is_student?
    @students = case params[:tab]
                when 'mine'
                  Student.with_teacher(current_user)
                else 
                  Student
                end.with_semester(get_semester).paginated(params[:page])
  end


end
