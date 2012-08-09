class Team < ActiveRecord::Base
  
  belongs_to :teacher
  
  has_many :team_students
  has_many :students, :through => :team_students
  
  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |team| !team.cid.blank? } }

  def get_user_ids
    [students, teacher].flatten.map(&:user_id).sort
  end

  def get_users
    User.find get_user_ids
  end

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      rows = CSV::parse(file.read)
      is_utf8 = rows[0].join(",").utf8?
      rows.each_with_index do |row,index|
        next if index == 0
        row = row.map{|v|(v || "").gb2312_to_utf8} if !is_utf8
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
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def teams
        Team.joins(:teacher, :students).where('teachers.user_id = :id or students.user_id = :id', :id => self.id)
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
