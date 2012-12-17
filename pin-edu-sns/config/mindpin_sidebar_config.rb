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
    group :default, :name => '管理员功能…' do

      nav :basic, :name => '基础数据', :url => '/admin' do
        controller :'admin/index', :only => :index

        subnav :overview, :name => '统计概览', :url => '/admin' do
          controller :'admin/index', :only => :index
        end

        subnav :teachers, :name => '教师数据', :url => '/admin/teachers' do
          controller :'admin/teachers'
        end

        subnav :students, :name => '学生数据', :url => '/admin/students' do
          controller :'admin/students'
        end

        subnav :courses, :name => '课程数据', :url => '/admin/courses' do
          controller :'admin/courses'
          controller :'admin/course_teachers'
        end

        subnav :teams, :name => '班级数据', :url => '/admin/teams' do
          controller :'admin/teams'
        end

        subnav :upload_document_dirs, :name => '文档目录', :url => '/admin/upload_document_dirs' do
          controller :'admin/upload_document_dirs'
        end

      end

      nav :teaching_plans, :name => '教学计划', :url => '/admin/teaching_plans' do
        controller :'admin/teaching_plans'
      end

      nav :course_surveys, :name => '课程调查', :url => '/admin/course_surveys' do
        controller :'admin/course_surveys'
      end

      nav :mentor, :name => '导师', :url => '/admin/mentor_courses' do
        subnav :mentor_courses, :name => '导师方向', :url => '/admin/mentor_courses' do
          controller :'admin/mentor_courses'
        end

        subnav :mentor_notes, :name => '导师双向选择', :url => '/admin/mentor_notes' do
          controller :'admin/mentor_notes'
        end
      end


      nav :categories, :name => '资源分类', :url => '/admin/categories' do
        controller :'admin/categories'
      end

      nav :announcements, :name => '通知管理', :url => '/admin/announcements' do
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

        subnav :score_lists, :name => '成绩单', :url => '/score_lists' do
          controller :score_lists
        end

        subnav :course_surveys, :name => '课程调查', :url => '/course_surveys' do
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
      nav :media_resources, :name => '媒体资源', :url => '/file' do
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

      nav :dashboard, :name => '我的工作台', :url => '/dashboard' do
        controller :index, :only => :dashboard

        subnav :dashboard, :name => '信息概览', :url => '/dashboard' do
          controller :index, :only => :dashboard
        end

        subnav :students, :name => '学生浏览', :url => '/students' do
          controller :students, :only => :index
        end

        subnav :teachers, :name => '老师浏览', :url => '/teachers' do
          controller :teachers, :only => :index
        end

        subnav :homeworks, :name => '我的作业和实践', :url => '/homeworks' do
          controller :homeworks
        end

        subnav :score_lists, :name => '成绩单', :url => '/score_lists/mine' do
          controller :score_lists
        end

        subnav :course_surveys, :name => '课程调查', :url => '/course_surveys' do
          controller :course_surveys
        end

        subnav :questions, :name => '在线问答', :url => '/questions' do
          controller :questions
        end

        subnav :mentor_students, :name => '导师双向选择', :url => '/mentor_students' do
          controller :mentor_students
        end
      end

      nav :course, :name => '课程', :url => '/courses/curriculum' do
        subnav :curriculum, :name => '我的课程表', :url => '/courses/curriculum' do
          controller :courses, :only => :curriculum
        end

        subnav :couses, :name => '课程浏览', :url => '/courses' do
          controller :courses, :only => [:index,:show]
        end

        subnav :couse_subscriptions, :name => '订阅的课程', :url => '/courses/subscriptions' do
          controller :courses, :only => :subscriptions
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
