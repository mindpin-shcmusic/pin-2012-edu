# -*- coding: utf-8 -*-
class StudentsController < ApplicationController
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

  private
  def _index_student
    @students = sort_scope(Student).paginated(params[:page])
  end

  def _index_teacher
    @students = case params[:tab]
      when 'mine'
        sort_scope(Student).with_teacher(current_user).with_semester(get_semester)
      else
        sort_scope(Student)
      end.paginated(params[:page])
  end

end
