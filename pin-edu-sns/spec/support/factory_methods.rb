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

  def make_a_course(number)
    make_a_course_or_team :course, number
  end

  def make_a_team(number)
    make_a_course_or_team :team, number
  end

  private

  def make_a_course_or_team(type, number)
    FactoryGirl.create type,
                       :teacher  => make_teachers(1)[0],
                       :students => make_students(number)
  end
end
