# -*- coding: utf-8 -*-
class TeachersController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
  end


  def index
    @teachers = Teacher.paginated(params[:page])
  end


end
