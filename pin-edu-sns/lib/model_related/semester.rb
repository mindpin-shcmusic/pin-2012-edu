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
end