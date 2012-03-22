class TodosController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @todo = Todo.find(params[:id]) if params[:id]
  end
  
  def new
    @todo = Todo.new
  end
  
  def create
    @todo = Todo.new(params[:todo])
    @todo.creator = current_user
    if @todo.save
      return redirect_to "/todos"
    end
    
    error = @todo.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/todos/new"
  end
  
  def index
    @unexpired_todos = current_user.unexpired_todos
    @expired_todos = current_user.expired_todos
    @completed_todos = current_user.completed_todos
  end
  
  def do_complete
    @todo.do_complete
    redirect_to "/todos"
  end
end
