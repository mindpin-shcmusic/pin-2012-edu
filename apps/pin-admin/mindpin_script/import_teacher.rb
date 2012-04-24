# 该脚本用来导入 教师
# 在工程根目录运行
# rails runner script/script/import_teacher.rb /xxx/data.csv

require "csv"

path = ARGV[0]
raise "需要指定csv 文件路径" if path.blank?
raise "#{path} 不是一个有效的文件路径" if !File.exists?(path)

ActiveRecord::Base.transaction do
  
  raw_count = 0
  CSV.open(path, 'r') do |row|
    raw_count+=1
    
    begin
      real_name = row[0]
      tid = row[1]
      teacher = Teacher.new(
        :real_name => real_name,
        :tid => tid
      )
      teacher.save!
    rescue Exception=>ex
      raise "第 #{raw_count}行解析出错,本次操作已经回滚"
    end
    
  end
end