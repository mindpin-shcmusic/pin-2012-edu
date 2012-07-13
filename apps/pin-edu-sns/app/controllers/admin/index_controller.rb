class Admin::IndexController < ApplicationController
  layout 'admin'
  before_filter :login_required
  def index
  end
end
