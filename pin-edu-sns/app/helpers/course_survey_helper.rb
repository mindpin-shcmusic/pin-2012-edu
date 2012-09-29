module CourseSurveyHelper

  def each_count(course_survey)


    on_off_class = 0
    checking_institution = 0
    class_order = 0

    prepare_situation_total_enough, prepare_situation_general_enough, prepare_situation_not_enough = 0, 0, 0
    teaching_level_good, teaching_level_general = 0, 0
    teacher_morality_good, teacher_morality_better = 0, 0

    class_content_rich_relation, class_content_general_relation = 0, 0
    knowledge_level_rich, knowledge_level_richer = 0, 0
    teaching_schedule_reasonable, teaching_schedule_basic_reasonable, teaching_schedule_not_reasonable = 0, 0, 0

    teaching_interact_good, teaching_interact_better = 0, 0
    board_writing_quality_good, board_writing_quality_general = 0, 0
    has_courseware_yes, has_courseware_no = 0, 0

    courseware_quality_good, courseware_quality_general = 0, 0
    speak_level_good, speak_level_general = 0, 0
    study_result_much, study_result_little, study_result_none = 0, 0, 0
    teaching_result_good, teaching_result_general, teaching_result_bad = 0, 0, 0
    result_reason_teacher, result_reason_student = 0, 0


    course_survey.course_survey_records.each do |record|

      on_off_class += 1 if record.on_off_class

      checking_institution += 1 if record.checking_institution
 
      class_order += 1 if record.class_order

      case record.prepare_situation
      when 'TOTAL_ENOUGH'
        prepare_situation_total_enough += 1
      when 'GENERAL_ENOUGH'
        prepare_situation_general_enough += 1
      when 'NOT_ENOUGH'
        prepare_situation_not_enough += 1
      end

      case record.teaching_level
      when 'GOOD'
        teaching_level_good += 1
      when 'GENERAL'
        teaching_level_general += 1
      end

      case record.teacher_morality
      when 'GOOD'
        teacher_morality_good += 1
      when 'BETTER'
        teacher_morality_better += 1
      end

      case record.class_content
      when 'RICH_RELATION'
        class_content_rich_relation += 1
      when 'GENERAL_RELATION'
        class_content_general_relation += 1
      end


      case record.knowledge_level
      when 'RICH'
        knowledge_level_rich += 1
      when 'RICHER'
        knowledge_level_richer += 1
      end

      case record.teaching_schedule
      when 'REASONABLE'
        teaching_schedule_reasonable += 1
      when 'BASIC_REASONABLE'
        teaching_schedule_basic_reasonable += 1
      when 'NOT_REASONABLE'
        teaching_schedule_not_reasonable += 1
      end

      
      case record.teaching_interact
      when 'GOOD'
        teaching_interact_good += 1
      when 'BETTER'
        teaching_interact_better += 1
      end
      

      case record.board_writing_quality
      when 'GOOD'
        board_writing_quality_good += 1
      when 'GENERAL'
        board_writing_quality_general += 1
      end


      case record.has_courseware
      when 'YES'
        has_courseware_yes += 1
      when 'NO'
        has_courseware_no += 1
      end


      case record.courseware_quality
      when 'GOOD'
        courseware_quality_good += 1
      when 'GENERAL'
        courseware_quality_general += 1
      end


      case record.speak_level
      when 'GOOD'
        speak_level_good += 1
      when 'GENERAL'
        speak_level_general += 1
      end



      case record.study_result
      when 'MUCH'
        study_result_much += 1
      when 'LITTLE'
        study_result_little += 1
      when 'NONE'
        study_result_none += 1
      end

      

      case record.teaching_result
      when 'GOOD'
        teaching_result_good += 1
      when 'GENERAL'
        teaching_result_general += 1
      when 'BAD'
        teaching_result_bad += 1
      end


      
      case record.result_reason
      when 'TEACHER_REASON'
        result_reason_teacher += 1
      when 'STUDENT_REASON'
        result_reason_student += 1
      end
    end


    
    {
      :on_off_class => on_off_class,
      :checking_institution => checking_institution,
      :class_order => class_order,
      :prepare_situation_total_enough => prepare_situation_total_enough, 
      :prepare_situation_general_enough => prepare_situation_general_enough, 
      :prepare_situation_not_enough => prepare_situation_not_enough,
      :teaching_level_good => teaching_level_good, 
      :teaching_level_general => teaching_level_general,
      :teacher_morality_good => teacher_morality_good, 
      :teacher_morality_better => teacher_morality_better, 
      :class_content_rich_relation => class_content_rich_relation, 
      :class_content_general_relation => class_content_general_relation, 
      :knowledge_level_rich => knowledge_level_rich, 
      :knowledge_level_richer => knowledge_level_richer, 
      :teaching_schedule_reasonable => teaching_schedule_reasonable, 
      :teaching_schedule_basic_reasonable => teaching_schedule_basic_reasonable, 
      :teaching_schedule_not_reasonable => teaching_schedule_not_reasonable, 
      :teaching_interact_good => teaching_interact_good, 
      :teaching_interact_better => teaching_interact_better, 
      :board_writing_quality_good => board_writing_quality_good, 
      :board_writing_quality_general => board_writing_quality_general, 
      :has_courseware_yes => has_courseware_yes, 
      :has_courseware_no => has_courseware_no,
      :courseware_quality_good => courseware_quality_good, 
      :courseware_quality_general => courseware_quality_general,
      :speak_level_good => speak_level_good, 
      :speak_level_general => speak_level_general,
      :study_result_much => study_result_much, 
      :study_result_little => study_result_little, 
      :study_result_none => study_result_none,
      :teaching_result_good => teaching_result_good, 
      :teaching_result_general => teaching_result_general, 
      :teaching_result_bad => teaching_result_bad, 
      :result_reason_teacher => result_reason_teacher, 
      :result_reason_student => result_reason_student
    }
  end


end