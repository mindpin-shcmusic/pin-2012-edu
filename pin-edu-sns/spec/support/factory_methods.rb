module FactoryMethods
  def make_users(number)
    1.upto(number).map {FactoryGirl.create(:user)}
  end

  def make_teachers(number)
    make_users(number).map {|user|
      FactoryGirl.create(:teacher, :user => user)
    }
  end

  def make_students(number)
    make_users(number).map {|user|
      FactoryGirl.create(:student, :user => user)
    }
  end

  def make_courses(number, student_number = 4)
    1.upto(number).map {make_a_course}
  end

  def make_a_course(student_number)
    make_a_course_or_team :course, student_number
  end

  def make_a_team(student_number)
    make_a_course_or_team :team, student_number
  end

  private

  def make_a_course_or_team(type, student_number)
    FactoryGirl.create type,
                       :teacher  => make_teachers(1)[0],
                       :students => make_students(student_number)
  end
end
