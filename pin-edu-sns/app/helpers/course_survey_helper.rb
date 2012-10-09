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

    records = course_survey.course_survey_records

    records_group = records.group_by(&:on_off_class)
    on_off_class = records_group['on_off_class'].length if !records_group['on_off_class'].nil?

    records_group = records.group_by(&:checking_institution)
    checking_institution = records_group['checking_institution'].length if !records_group['checking_institution'].nil?


    records_group = records.group_by(&:class_order)
    class_order = records_group['class_order'].length if !records_group['class_order'].nil?


    records_group = records.group_by(&:prepare_situation)
    prepare_situation_total_enough = records_group['TOTAL_ENOUGH'].length if !records_group['TOTAL_ENOUGH'].nil?
    prepare_situation_general_enough = records_group['GENERAL_ENOUGH'].length if !records_group['GENERAL_ENOUGH'].nil?
    prepare_situation_not_enough = records_group['NOT_ENOUGH'].length if !records_group['NOT_ENOUGH'].nil?


    records_group = records.group_by(&:teaching_level)
    teaching_level_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    teaching_level_general = records_group['GENERAL'].length if !records_group['GENERAL'].nil?


    records_group = records.group_by(&:teacher_morality)
    teacher_morality_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    teacher_morality_better = records_group['BETTER'].length if !records_group['BETTER'].nil?


    records_group = records.group_by(&:class_content)
    class_content_rich_relation = records_group['RICH_RELATION'].length if !records_group['RICH_RELATION'].nil?
    class_content_general_relation = records_group['GENERAL_RELATION'].length if !records_group['GENERAL_RELATION'].nil?


    records_group = records.group_by(&:knowledge_level)
    knowledge_level_rich = records_group['RICH'].length if !records_group['RICH'].nil?
    knowledge_level_richer = records_group['RICHER'].length if !records_group['RICHER'].nil?


    records_group = records.group_by(&:teaching_schedule)
    teaching_schedule_reasonable = records_group['REASONABLE'].length if !records_group['REASONABLE'].nil?
    teaching_schedule_basic_reasonable = records_group['BASIC_REASONABLE'].length if !records_group['BASIC_REASONABLE'].nil?
    teaching_schedule_not_reasonable = records_group['NOT_REASONABLE'].length if !records_group['NOT_REASONABLE'].nil?


    records_group = records.group_by(&:teaching_interact)
    teaching_interact_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    teaching_interact_better = records_group['BETTER'].length if !records_group['BETTER'].nil?


    records_group = records.group_by(&:board_writing_quality)
    board_writing_quality_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    board_writing_quality_general = records_group['GENERAL'].length if !records_group['GENERAL'].nil?


    records_group = records.group_by(&:has_courseware)
    has_courseware_yes = records_group['has_courseware'].length if !records_group['has_courseware'].nil?
    has_courseware_yes = records_group['has_courseware'].length if !records_group['has_courseware'].nil?


    records_group = records.group_by(&:has_courseware)
    has_courseware_yes = records_group['YES'].length if !records_group['YES'].nil?
    has_courseware_no = records_group['NO'].length if !records_group['NO'].nil?

    records_group = records.group_by(&:courseware_quality)
    courseware_quality_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    courseware_quality_general = records_group['GENERAL'].length if !records_group['GENERAL'].nil?


    records_group = records.group_by(&:speak_level)
    speak_level_good = records_group['speak_level'].length if !records_group['speak_level'].nil?
    speak_level_general = records_group['speak_level'].length if !records_group['speak_level'].nil?


    records_group = records.group_by(&:speak_level)
    speak_level_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    speak_level_general = records_group['GENERAL'].length if !records_group['GENERAL'].nil?

    records_group = records.group_by(&:study_result)
    study_result_much = records_group['MUCH'].length if !records_group['MUCH'].nil?
    study_result_little = records_group['LITTLE'].length if !records_group['LITTLE'].nil?
    study_result_none = records_group['NONE'].length if !records_group['NONE'].nil?


    records_group = records.group_by(&:teaching_result)
    teaching_result_good = records_group['GOOD'].length if !records_group['GOOD'].nil?
    teaching_result_general = records_group['GENERAL'].length if !records_group['GENERAL'].nil?
    teaching_result_bad = records_group['BAD'].length if !records_group['BAD'].nil?

    records_group = records.group_by(&:result_reason)
    result_reason_teacher = records_group['TEACHER_REASON'].length if !records_group['TEACHER_REASON'].nil?
    result_reason_student = records_group['STUDENT_REASON'].length if !records_group['STUDENT_REASON'].nil?

=begin

    records.each do |record|

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
=end

    
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