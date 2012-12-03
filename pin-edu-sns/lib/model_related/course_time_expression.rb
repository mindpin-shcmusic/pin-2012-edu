class CourseTimeExpression
  attr_reader :weekday, :numbers, :weekday_str, :start_time_str, :end_time_str
  attr_accessor :course_teacher
  def initialize(weekday, numbers)
    @weekday = weekday.to_i
    @numbers = numbers.map{|n|n.to_i}
    set_weekday_str
    set_start_time
    set_end_time
  end

  def set_weekday_str
    @weekday_str = case @weekday
    when 1 then '周一'
    when 2 then '周二'
    when 3 then '周三' 
    when 4 then '周四'
    when 5 then '周五'
    when 6 then '周六'
    when 0 then '周日'
    end
  end

  def set_start_time
    @start_time_str = case @numbers.first
    when 1 then '8:00'
    when 2 then '8:45'
    when 3 then '10:00'
    when 4 then '10:45'
    when 5 then '11:50'
    when 6 then '12:35'
    when 7 then '13:30'
    when 8 then '14:15'
    when 9 then '15:30'
    when 10 then '16:15'
    when 11 then '18:00'
    when 12 then '18:45'
    end
  end

  def set_end_time
    @end_time_str = case @numbers.last
    when 1 then '8:45'
    when 2 then '9:30'
    when 3 then '10:45'
    when 4 then '11:30'
    when 5 then '12:35'
    when 6 then '13:20'
    when 7 then '14:15'
    when 8 then '15:00'
    when 9 then '16:15'
    when 10 then '17:00'
    when 11 then '18:45'
    when 12 then '19:30'
    end
  end

  def class_time
    "#{self.start_time_str} - #{self.end_time_str}"
  end

  def >=(other)
    self > other || self == other
  end

  def <=(other)
    self < other || self == other
  end

  def ==(other)
    return true if self.weekday == other.weekday && !(self.numbers & other.numbers).blank?
    return false
  end

  def >(other)
    return false if self == other


    if ((self.weekday+7)%8) != ((other.weekday+7)%8)
      return ((self.weekday+7)%8) > ((other.weekday+7)%8)
    end

    self.numbers.first > other.numbers.first
  end

  def <(other)
    other > self
  end

  def self.get_by_time(time)
    number = case time.strftime("%H%M").to_i
    when 0...800 then 0
    when 800...845 then 1
    when 845...930 then 2
    when 930...1000 then 2.5
    when 1000...1045 then 3
    when 1045...1130 then 4
    when 1130...1150 then 4.5
    when 1150...1235 then 5
    when 1235...1320 then 6
    when 1320...1330 then 6.5
    when 1330...1415 then 7
    when 1415...1500 then 8
    when 1500...1530 then 8.5
    when 1530...1615 then 9
    when 1615...1700 then 10
    when 1700...1800 then 10.5
    when 1800...1845 then 11
    when 1845...1930 then 12
    when 1930...2400 then 13
    end
    self.new(time.wday,[number])
  end
end