class Semester
  class UnknowSectionError < Exception; end

  attr_reader :value
  def initialize(year, section)
    @year = year
    @section = section
    @value = "#{year}#{section.to_s}"
  end

  def self.get(year, section)
    raise UnknowSectionError.new if ![:A,:B].include?(section)
    self.new(year, section)
  end

  def self.get_by_value(value)
    year = value[0...-1]
    section = value[-1..-1]
    self.get(year, section.to_sym)
  end

  def self.now
    self.of_time Time.now
  end

  def self.of_time(time)
    year = time.year
    month = time.month
    case month
    when 1,2 #上一年 B
      self.new(year-1,:B)
    when 3,4,5,6,7,8 # 本年 A
      self.new(year,:A)
    when 9,10,11,12 # 本年 B
      self.new(year,:B)
    end
  end

  def ==(other)
    self.value == other.value
  end

  def prev
    if @section == :B
      self.class.get(@year,:A)
    else
      self.class.get(@year.to_i-1,:B)
    end
  end

  def next
    if @section == :B
      self.class.get(@year.to_i+1,:A)
    else
      self.class.get(@year,:B)
    end
  end

  def self.get_nav_array
    now_semester = self.now
    now_semester_prev = now_semester.prev
    now_semester_prev_prev = now_semester_prev.prev

    [
      now_semester_prev_prev,
      now_semester_prev,
      now_semester
    ]
  end

  def get_courses
    Course.joins("inner join course_teachers on course_teachers.course_id = courses.id").
      where("course_teachers.semester_value = '#{self.value}'").uniq
  end
end