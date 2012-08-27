# -*- coding: utf-8 -*-
class Team < ActiveRecord::Base
  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  has_many :team_students

  has_many :student_users,
           :through => :team_students,
           :source  => :student_user

  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |team| !team.cid.blank? } }

  def get_user_ids
    get_users.map(&:id).sort
  end

  def get_users
    [student_users, teacher_user].flatten.uniq
  end

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        team = Team.new(:name => row[0],:cid => row[1])
        if !team.save
          message = team.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :teacher_teams,
                    :class_name  => 'Team',
                    :foreign_key => :teacher_user_id

      base.has_one  :team_student, :foreign_key => :student_user_id
      base.has_one  :student_team,
                    :through => :team_student,
                    :source  => :team
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def teams
        return [self.student_team] if self.is_student?
        return self.teacher_teams if self.is_teacher?
        []
      end
    end
  end

  include ModelRemovable
  include Paginated

  define_index do
    indexes name, :sortable => true

    where('is_removed = 0')
  end
end
