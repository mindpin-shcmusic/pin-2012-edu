# -*- coding: utf-8 -*-
class MediaSharesController < ApplicationController

  def index
    # 共享给我的用户列表
    @shared_users = current_user.linked_sharers
  end

  def new
    resource_path = params[:resource_path].sub('/file', '')
    @current_dir = MediaResource.get(current_user, resource_path)
    @users = User.where("id != ? AND id != ?", current_user.id, 1)
    @shared_receivers = @current_dir.shared_receivers

    @courses = current_user.courses
    @teams   = current_user.teams
  end

  def create
    media_resource = MediaResource.find(params[:media_resource_id])

    media_resource.share_to_expression params[:receivers].to_json

    redirect_to params[:resource_path].split(/\//)[0..-2].join('/')
  end

  # 分享给其它用户目录
  def share
    if params[:path].blank?

      @sharer = User.find(params[:user_id])
      @media_resources = current_user.shared_resources_from(@sharer)
      @prev = :base
      return
    end

    resource_path = "/#{params[:path]}"

    @sharer = User.find(params[:user_id])
    @current_dir = MediaResource.get(@sharer, resource_path)
    @media_resources = @current_dir.media_resources.web_order
    @prev = @current_dir.dir
    @prev = @sharer if @prev.blank?
  end

  # 搜索共享资源
  def search
    @keyword = params[:keyword]
    shared_resources = MediaShare.search(@keyword, 
      :conditions => {:receiver_id => current_user.id}, 
      :page => params[:page], :per_page => 20)
    
    @media_resources = []
    shared_resources.each do |shared|
      @media_resources << shared.media_resource
    end
  end

end
