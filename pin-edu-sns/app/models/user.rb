# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # admin 模块
  include Student::UserMethods
  include Teacher::UserMethods
  # --- 作业
  include Homework::UserMethods
  include HomeworkAssign::UserMethods
  include HomeworkStudentUploadRequirement::UserMethods
  include HomeworkStudentUpload::UserMethods
  # --- 通知
  include Notification::UserMethods
  # --- 站内信
  include ShortMessage::UserMethods

  # 如果该声明放在 MediaResource::UserMethods 上 会导致引用出现异常
  # 只能在这里声明了 fushang318
  has_many :media_resources,
                    :foreign_key => 'creator_id'
  include MediaShare::UserMethods
  include PublicResource::UserMethods
  include RedisSearchMethods::UserMethods
  include MediaShareRule::UserMethods
  include Achievement::UserMethods
  include Course::UserMethods
  include Team::UserMethods

  ###
  include UserAvatarMethods
  include UserAuthMethods
  # 在线状态记录
  has_one :online_record,:dependent => :destroy

  # 校验部分
  # 不能为空的有：用户名，登录名，电子邮箱
  # 不能重复的有：登录名，电子邮箱（大小写不区分）
  # 两次密码输入必须一样，电子邮箱格式必须正确
  # 密码允许为空，但是如果输入了，就必须是4-32
  # 用户名：是2-20位的中文或者英文，可以混写
  validates :email,
    :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => /^([A-Za-z0-9_]+)([\.\-\+][A-Za-z0-9_]+)*(\@[A-Za-z0-9_]+)([\.\-][A-Za-z0-9_]+)*(\.[A-Za-z0-9_]+)$/

  validates :name, 
    :presence => true,
    :length => 2..20,
    :uniqueness => { :case_sensitive => false },
    :format => /^([A-Za-z0-9一-龥]+)$/

  validates :password,
    :presence => { :on => :create },
    :confirmation => true,
    :length => { :in => 4..32 , :on => :create}

  def is_admin?
    "admin" == self.name && 1 == self.id
  end
end
