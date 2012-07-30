class Course < ActiveRecord::Base
  belongs_to :teacher

  has_many :course_students
  has_many :students, :through => :course_students

  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |course| !course.cid.blank? } }

  def get_user_ids
    [students, teacher].flatten.map(&:user_id).sort
  end

  def get_users
    User.find get_user_ids
  end

  include Removable
  include Paginated

  module UserMethods
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def courses
        Course.joins(:teacher, :students).where('teachers.user_id = :id or students.user_id = :id', :id => self.id)
      end
    end
  end
end
