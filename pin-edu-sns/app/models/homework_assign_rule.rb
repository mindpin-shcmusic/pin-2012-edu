# -*- coding: undecided -*-
class HomeworkAssignRule < ActiveRecord::Base
  attr_accessor :deleting
  after_save :enqueue_build_assign

  belongs_to :homework

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  def build_expression(options = {})
    options.assert_valid_keys :teams

    options[:teams] ||= []

    @deleting = persisted? ? deleting_assignee_ids(options) : []

    delete_assign
    
    self.expression = options.to_json
  end

  def expression
    exp = read_attribute(:expression)
    exp && JSON.parse(exp, :symbolize_names => true).reduce({}) do |sanitized, (k, v)|
      sanitized[k] = v.map(&:to_i)
      sanitized
    end
  end

  def expression_assignee_ids
    Team.find(expression[:teams]).map(&:students).flatten.map(&:id).sort
  end

  def expression_assignees
    Student.find expression_assignee_ids
  end

  def deleting_assignees
    Student.find deleting_assignee_ids
  end

  def delete_assign
    HomeworkAssign.where('homework_id = ? and student_id in (?)', self.homework_id, self.deleting).delete_all
  end

  def build_assign
    expression_assignees.each {|assignee|
      assign = HomeworkAssign.find_or_initialize_by_homework_id_and_student_id self.homework.id,
                                                                               assignee.id
      assign.creator = self.creator
      assign.save
    }
  end

  private

  def deleting_assignee_ids(options)
    return [] if expression.nil?
    deleted_team_ids = ArrayDiff.deleted(expression[:teams], options[:teams].map(&:to_i))
    Team.find(deleted_team_ids).map(&:students).flatten.map(&:id)
  end

  def enqueue_build_assign
    BuildHomeworkAssignResqueQueue.enqueue(self.id)
  end

  module UserMethods
    def self.included(base)
      base.has_many :homework_assign_rules,
                    :foreign_key => 'creator_id'
    end
  end

  module HomeworkMethods
    def self.included(base)
      base.has_one :homework_assign_rule

      base.send    :include,
                   InstanceMethods
    end

    module InstanceMethods
      def share_to(options)
        rule = HomeworkAssignRule.find_or_initialize_by_homework_id(self.id)
        rule.creator = self.creator

        rule.build_expression(options)
        rule.save
      end

      def share_to_expression(expression_string)
        share_to(JSON.parse expression_string, :symbolize_names => true)
      end

    end

  end

end

