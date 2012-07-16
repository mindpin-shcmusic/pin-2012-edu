module TodoHelper
  
  # 根据传入的日期对象，获得一个以该日期对应的星期作为第二天的一个字符串数组
  # 2 -> [1, 2, 3, 4, 5, 6, 7]
  # 3 -> [2, 3, 4, 5, 6, 7, 1]
  def weekday_strs_arr(date)
    wday = date.localtime.wday
    
    arr = {
      1 => [7, 1, 2, 3, 4, 5, 6],
      2 => [1, 2, 3, 4, 5, 6, 7],
      3 => [2, 3, 4, 5, 6, 7, 1],
      4 => [3, 4, 5, 6, 7, 1, 2],
      5 => [4, 5, 6, 7, 1, 2, 3],
      6 => [5, 6, 7, 1, 2, 3, 4],
      7 => [6, 7, 1, 2, 3, 4, 5]
    }[wday].map{|x| _weekday_str(x)}
    
    return arr
  end
  
  def weekday_str(date)
    wday = date.localtime.wday
    return _weekday_str(wday)
  end
  
  def _weekday_str(wday)    
    return {
      1 => :周一,
      2 => :周二,
      3 => :周三,
      4 => :周四,
      5 => :周五,
      6 => :周六,
      7 => :周日
    }[wday]
  end
  
end