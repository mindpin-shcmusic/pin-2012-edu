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
end