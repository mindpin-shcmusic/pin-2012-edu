# -*- coding: utf-8 -*-
MindpinSidebar::Base.config do
  # example
  # 
  # rule :admin do
  #   nav :students, :name => '学生', :url => '/admin/students' do
  #     controller :'admin/students'
  #     subnav :student_info, :name => '学生信息', :url => '/admin/students/info' do
  #       controller :'admin/student_infos'
  #     end
  #   end
  # end

  # rule [:teacher,:student] do
  #   nav :media_resources, :name => '我的文件夹', :url => '/file' do
  #     controller :media_resources, :except => [:xxx]
  #     controller :file_entities, :only => [:upload]
  #   end
  # end

  rule :admin do
    group :default, :name => '教务功能…' do
      nav :home, :name => '首页', :url => '/admin' do
        controller :'admin/index'
      end

      nav :teaching_plans, :name => '教学计划', :url => '/admin/teaching_plans' do
        controller :'admin/teaching_plans'
      end

      nav :students, :name => '学籍管理', :url => '/admin/students' do
        controller :'admin/students'
      end

      nav :teams, :name => '班级管理', :url => '/admin/teams' do
        controller :'admin/teams'
      end

      nav :courses, :name => '课程管理', :url => '/admin/courses' do
        controller :'admin/courses'
        controller :'admin/course_teachers'
      end

      nav :course_score_records, :name => '成绩管理', :url => '/admin/course_score_records' do
        controller :'admin/course_score_records'
      end

      nav :teachers, :name => '教师管理', :url => '/admin/teachers' do
        controller :'admin/teachers'
      end

      nav :course_surveys, :name => '课堂教学评价', :url => '/admin/course_surveys' do
        controller :'admin/course_surveys'
      end

      nav :categories, :name => '资源分类管理', :url => '/admin/categories' do
        controller :'admin/categories'
      end

      nav :announcements, :name => '公告', :url => '/admin/announcements' do
        controller :'admin/announcements'
      end
    end
  end

  # -------------------------
  # 教师
  rule :teacher do
    group :resources, :name => '教师功能…' do

      nav :dashboard, :name => '教学工作台', :url => '/dashboard' do
        controller :index, :only => :dashboard

        subnav :dashboard, :name => '信息概览', :url => '/dashboard' do
          controller :index, :only => :dashboard
        end

        subnav :homeworks, :name => '布置的作业和实践', :url => '/homeworks' do
          controller :homeworks
          controller :homework_assigns
        end

        subnav :course_surveys, :name => '在线调查', :url => '/course_surveys' do
          controller :course_surveys
        end

        subnav :questions, :name => '在线问答', :url => '/questions' do
          controller :questions
        end
      end

      nav :'teaching-info', :name => '教学信息', :url => '/teachers' do
        subnav :teachers, :name => '教师浏览', :url => '/teachers' do
          controller :teachers, :only => :index
        end

        subnav :students, :name => '学生浏览', :url => '/students' do
          controller :students, :only => :index
        end

        subnav :courses, :name => '课程浏览', :url => '/courses' do
          controller :courses, :only => [:index,:show]
        end

        subnav :couse_subscriptions, :name => '订阅的课程', :url => '/courses/subscriptions' do
          controller :courses, :only => :subscriptions
        end
      end

      nav :'media-resources', :name => '媒体资源', :url => '/file' do
        controller :media_resources

        subnav :my_resources, :name => '我的文件夹', :url => '/file' do
          controller :media_resources
        end

        subnav :media_shares, :name => '收到的共享', :url => '/media_shares' do
          controller :media_shares
        end

        subnav :public_resources, :name => '公共资源库', :url => '/public_resources' do
          controller :public_resources
        end
      end

      nav :course, :name => '课程', :url => '/courses/curriculum' do
        subnav :curriculum, :name => '我的课程表', :url => '/courses/curriculum' do
          controller :courses, :only => :curriculum
        end
      end

      nav :notice, :name => '系统通知', :url => '/announcements' do
        controller :announcements

        subnav :announcements, :name => '通知', :url => '/announcements' do
          controller :announcements
        end

        subnav :comments, :name => '收到的评论', :url => '/comments/received' do
          controller :comments
        end
      end
    end
  end

  # ------------------
  # 学生
  rule :student do
    group :resources, :name => '学生功能…' do

      nav :dashboard, :name => '课程首页', :url => '/dashboard' do
        controller :index, :only => :dashboard
      end

      nav :media_resources, :name => '资源网盘', :url => '/file' do
        subnav :my_resources, :name => '我的文件夹', :url => '/file' do
          controller :media_resources
        end

        subnav :media_shares, :name => '收到的共享', :url => '/media_shares' do
          controller :media_shares
        end

        subnav :public_resources, :name => '公共资源库', :url => '/public_resources' do
          controller :public_resources
        end
      end

      nav :notice, :name => '系统通知', :url => '/announcements' do
        controller :announcements

        subnav :announcements, :name => '通知', :url => '/announcements' do
          controller :announcements
        end

        subnav :comments, :name => '收到的评论', :url => '/comments/received' do
          controller :comments
        end
      end

    end
  end
end
