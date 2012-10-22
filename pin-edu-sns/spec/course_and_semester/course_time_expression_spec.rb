require 'spec_helper'

describe CourseTimeExpression do
  it 'course_time_expression' do
    cte = CourseTimeExpression.new(1,[3,4])
    cte.weekday_str.should == "周一"
    cte.start_time_str.should == "10:00"
    cte.end_time_str.should == "11:30"
    cte.weekday.should == 1
    cte.numbers.should == [3,4]

    time = Time.mktime(2012, 10, 22, 16)
    cte_1 = CourseTimeExpression.get_by_time(time)
    cte_1.weekday_str.should == "周一"
    cte_1.start_time_str.should == "15:30"
    cte_1.end_time_str.should == "16:15"
    cte_1.weekday.should == 1
    cte_1.numbers.should == [9]

    (cte_1 > cte).should == true
  end
end