MindpinSidebar::Base.config do
  # example
  # 
  # rule :admin do
  #   nav :students, :name => "学生", :url => "/admin/students" do
  #     controller :"admin/students"
  #     subnav :student_info, :name => "学生信息", :url => "/admin/students/info" do
  #       controller :"admin/student_infos"
  #     end
  #   end
  # end

  # rule [:teacher,:student] do
  #   nav :media_resources, :name => "我的文件夹", :url => "/file" do
  #     controller :media_resources, :except => [:xxx]
  #     controller :file_entities, :only => [:upload]
  #   end
  # end

  rule :admin do
    group :default, :name => "管理" do

      nav :overview, :name => "总体概览", :url => "/admin" do
        controller :"admin/index", :only => [:index]
      end

      nav :teachers, :name => "教师", :url => "/admin/teachers" do
        controller :"admin/teachers"
      end

      nav :students, :name => "学生", :url => "/admin/students" do
        controller :"admin/students"
      end

      nav :courses, :name => "课程", :url => "/admin/courses" do
        controller :"admin/courses"
        controller :"admin/course_teachers"
      end

      nav :teams, :name => "班级", :url => "/admin/teams" do
        controller :"admin/teams"
      end

      nav :teaching_plans, :name => "教学计划", :url => "/admin/teaching_plans" do
        controller :"admin/teaching_plans"
      end

      nav :course_surveys, :name => "课程调查", :url => "/admin/course_surveys" do
        controller :"admin/course_surveys"
      end

      nav :mentor_courses, :name => "导师方向", :url => "/admin/mentor_courses" do
        controller :"admin/mentor_courses"
      end

      nav :mentor_notes, :name => "导师双向选择", :url => "/admin/mentor_notes" do
        controller :"admin/mentor_notes"
      end

      nav :categories, :name => "资源分类", :url => "/admin/categories" do
        controller :"admin/categories"
      end

      nav :announcements, :name => "通知管理", :url => "/admin/announcements" do
        controller :"admin/announcements"
      end
    end
  end

  rule :teacher do
    group :resources, :name => "资源" do
      nav :media_resources, :name => "我的文件夹", :url => "/file" do
        controller :media_resources
      end

      nav :media_shares, :name => "收到的共享", :url => "/media_shares" do
        controller :media_shares
      end

      nav :public_resources, :name => "公共资源库", :url => "/public_resources" do
        controller :public_resources
      end
    end

    group :teaching, :name => "教学" do
      nav :dashboard, :name => "我的工作台", :url => "/dashboard" do
        controller :index, :only => :dashboard
      end

      nav :curriculum, :name => "我的课程表", :url => "/courses/for_teacher" do
        controller :courses
      end

      nav :homeworks, :name => "布置的作业和实践", :url => "/homeworks" do
        controller :homeworks
      end

      nav :score_lists, :name => "成绩单", :url => "/score_lists" do
        controller :score_lists
      end

      nav :course_surveys, :name => "课程调查", :url => "/course_surveys" do
        controller :course_surveys
      end

      nav :questions, :name => "在线问答", :url => "/questions" do
        controller :questions
      end
    end

    group :interactive, :name => "互动" do
      nav :comments, :name => "收到的评论", :url => "/comments/received" do
        controller :comments
      end

      nav :announcements, :name => "通知", :url => "/announcements" do
        controller :announcements
      end
    end
  end

  rule :student do
    group :resources, :name => "资源" do
      nav :media_resources, :name => "我的文件夹", :url => "/file" do
        controller :media_resources
      end

      nav :media_shares, :name => "收到的共享", :url => "/media_shares" do
        controller :media_shares
      end

      nav :public_resources, :name => "公共资源库", :url => "/public_resources" do
        controller :public_resources
      end
    end

    group :teaching, :name => "教学" do
      nav :dashboard, :name => "我的工作台", :url => "/dashboard" do
        controller :index, :only => :dashboard
      end

      nav :curriculum, :name => "我的课程表", :url => "/courses/for_student" do
        controller :courses
      end

      nav :homeworks, :name => "我的作业和实践", :url => "/homeworks" do
        controller :homeworks
      end

      nav :score_lists, :name => "成绩单", :url => "/score_lists/mine" do
        controller :score_lists
      end

      nav :course_surveys, :name => "课程调查", :url => "/course_surveys" do
        controller :course_surveys
      end

      nav :questions, :name => "在线问答", :url => "/questions" do
        controller :questions
      end

      nav :mentor_students, :name => "导师双向选择", :url => "/mentor_students" do
        controller :mentor_students
      end
    end

    group :interactive, :name => "互动" do
      nav :comments, :name => "收到的评论", :url => "/comments/received" do
        controller :comments
      end

      nav :announcements, :name => "通知", :url => "/announcements" do
        controller :announcements
      end
    end
  end
end