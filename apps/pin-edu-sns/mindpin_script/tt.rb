require "csv"

path = ARGV[0]
raise "需要指定csv 文件路径" if path.blank?
raise "#{path} 不是一个有效的文件路径" if !File.exists?(path)