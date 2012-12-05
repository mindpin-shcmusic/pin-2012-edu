# -*- coding: utf-8 -*-
class TeachersController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
  end


  def index
    if current_user.is_student?
      _index_student
    elsif current_user.is_teacher?
      _index_teacher
    end
  end

  def _index_student
    @teachers = case params[:tab]
      when 'mine'
        sort_scope(Teacher).with_student(current_user).with_semester(get_semester)
      else
        sort_scope(Teacher)
      end.paginated(params[:page])
  end

  def _index_teacher
    @teachers = sort_scope(Teacher).paginated(params[:page])
  end

end
