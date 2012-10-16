module CourseSurveyHelper

  def each_count(course_survey)


    on_off_class_a, on_off_class_b, on_off_class_c  = 0, 0, 0
    checking_institution_a, checking_institution_b, checking_institution_c = 0, 0, 0
    class_order_a, class_order_b, class_order_c = 0, 0, 0

    prepare_situation_a, prepare_situation_b, prepare_situation_c = 0, 0, 0
    teaching_level_a, teaching_level_b, teaching_level_c = 0, 0, 0
    teacher_morality_a, teacher_morality_b, teacher_morality_c = 0, 0, 0

    class_content_a, class_content_b, class_content_c = 0, 0, 0
    knowledge_level_a, knowledge_level_b, knowledge_level_c = 0, 0, 0
    teaching_schedule_a, teaching_schedule_b, teaching_schedule_c = 0, 0, 0

    teaching_interact_a, teaching_interact_b, teaching_interact_c = 0, 0, 0
    board_writing_quality_a, board_writing_quality_b, board_writing_quality_c = 0, 0, 0
    has_courseware_a, has_courseware_b = 0, 0

    courseware_quality_a, courseware_quality_b, courseware_quality_c = 0, 0, 0
    speak_level_a, speak_level_b, speak_level_c = 0, 0, 0
    study_result_much, study_result_b, study_result_c = 0, 0, 0
    teaching_result_a, teaching_result_b, teaching_result_c = 0, 0, 0
    result_reason_a, result_reason_b, result_reason_c = 0, 0, 0

    records = course_survey.course_survey_records

    records_group = records.group_by(&:on_off_class)
    on_off_class_a = records_group['A'].length if !records_group['A'].nil?
    on_off_class_b = records_group['B'].length if !records_group['B'].nil?
    on_off_class_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:checking_institution)
    checking_institution_a = records_group['A'].length if !records_group['A'].nil?
    checking_institution_b = records_group['B'].length if !records_group['B'].nil?
    checking_institution_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:class_order)
    class_order_a = records_group['A'].length if !records_group['A'].nil?
    class_order_b = records_group['B'].length if !records_group['B'].nil?
    class_order_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:prepare_situation)
    prepare_situation_a = records_group['A'].length if !records_group['A'].nil?
    prepare_situation_b = records_group['B'].length if !records_group['B'].nil?
    prepare_situation_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:teaching_level)
    teaching_level_a = records_group['A'].length if !records_group['A'].nil?
    teaching_level_b = records_group['B'].length if !records_group['B'].nil?
    teaching_level_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:teacher_morality)
    teacher_morality_a = records_group['A'].length if !records_group['A'].nil?
    teacher_morality_b = records_group['B'].length if !records_group['B'].nil?
    teacher_morality_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:class_content)
    class_content_a = records_group['A'].length if !records_group['A'].nil?
    class_content_b = records_group['B'].length if !records_group['B'].nil?
    class_content_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:knowledge_level)
    knowledge_level_a = records_group['A'].length if !records_group['A'].nil?
    knowledge_level_b = records_group['B'].length if !records_group['B'].nil?
    knowledge_level_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:teaching_schedule)
    teaching_schedule_a = records_group['A'].length if !records_group['A'].nil?
    teaching_schedule_b = records_group['B'].length if !records_group['B'].nil?
    teaching_schedule_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:teaching_interact)
    teaching_interact_a = records_group['A'].length if !records_group['A'].nil?
    teaching_interact_b = records_group['B'].length if !records_group['B'].nil?
    teaching_interact_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:board_writing_quality)
    board_writing_quality_a = records_group['A'].length if !records_group['A'].nil?
    board_writing_quality_b = records_group['B'].length if !records_group['B'].nil?
    board_writing_quality_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:has_courseware)
    has_courseware_a = records_group['A'].length if !records_group['A'].nil?
    has_courseware_b = records_group['B'].length if !records_group['B'].nil?


    records_group = records.group_by(&:courseware_quality)
    courseware_quality_a = records_group['A'].length if !records_group['A'].nil?
    courseware_quality_b = records_group['B'].length if !records_group['B'].nil?
    courseware_quality_c = records_group['C'].length if !records_group['C'].nil?

    records_group = records.group_by(&:speak_level)
    speak_level_a = records_group['A'].length if !records_group['A'].nil?
    speak_level_b = records_group['B'].length if !records_group['B'].nil?
    speak_level_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:speak_level)
    speak_level_a = records_group['A'].length if !records_group['A'].nil?
    speak_level_b = records_group['B'].length if !records_group['B'].nil?
    speak_level_c = records_group['C'].length if !records_group['C'].nil?

    records_group = records.group_by(&:study_result)
    study_result_a = records_group['A'].length if !records_group['A'].nil?
    study_result_b = records_group['B'].length if !records_group['B'].nil?
    study_result_c = records_group['C'].length if !records_group['C'].nil?


    records_group = records.group_by(&:teaching_result)
    teaching_result_a = records_group['A'].length if !records_group['A'].nil?
    teaching_result_b = records_group['B'].length if !records_group['B'].nil?
    teaching_result_c = records_group['C'].length if !records_group['C'].nil?

    records_group = records.group_by(&:result_reason)
    result_reason_a = records_group['A'].length if !records_group['A'].nil?
    result_reason_b = records_group['B'].length if !records_group['B'].nil?
    result_reason_c = records_group['C'].length if !records_group['C'].nil?

    
    {
      :on_off_class_a => on_off_class_a,
      :on_off_class_b => on_off_class_b,
      :on_off_class_c => on_off_class_c,

      :checking_institution_a => checking_institution_a,
      :checking_institution_b => checking_institution_b,
      :checking_institution_c => checking_institution_c,

      :class_order_a => class_order_a,
      :class_order_b => class_order_b,
      :class_order_c => class_order_c,

      :prepare_situation_a => prepare_situation_a, 
      :prepare_situation_b => prepare_situation_b, 
      :prepare_situation_c => prepare_situation_c,

      :teaching_level_a => teaching_level_a, 
      :teaching_level_b => teaching_level_b,
      :teaching_level_c => teaching_level_c, 

      :teacher_morality_a => teacher_morality_a, 
      :teacher_morality_b => teacher_morality_b,
      :teacher_morality_c => teacher_morality_c,

      :class_content_a => class_content_a, 
      :class_content_b => class_content_b, 
      :class_content_c => class_content_c, 

      :knowledge_level_a => knowledge_level_a, 
      :knowledge_level_b => knowledge_level_b, 
      :knowledge_level_c => knowledge_level_c,

      :teaching_schedule_a => teaching_schedule_a, 
      :teaching_schedule_b => teaching_schedule_b, 
      :teaching_schedule_c => teaching_schedule_c,

      :teaching_interact_a => teaching_interact_a, 
      :teaching_interact_b => teaching_interact_b, 
      :teaching_interact_c => teaching_interact_c, 

      :board_writing_quality_a => board_writing_quality_a, 
      :board_writing_quality_b => board_writing_quality_b, 
      :board_writing_quality_c => board_writing_quality_c, 

      :has_courseware_a => has_courseware_a, 
      :has_courseware_b => has_courseware_b,

      :courseware_quality_a => courseware_quality_a, 
      :courseware_quality_b => courseware_quality_b,
      :courseware_quality_c => courseware_quality_c, 

      :speak_level_a => speak_level_a, 
      :speak_level_b => speak_level_b,
      :speak_level_c => speak_level_c,

      :study_result_a => study_result_a, 
      :study_result_b => study_result_b, 
      :study_result_c => study_result_c,

      :teaching_result_a => teaching_result_a, 
      :teaching_result_b => teaching_result_b, 
      :teaching_result_c => teaching_result_c, 

      :result_reason_a => result_reason_a, 
      :result_reason_b => result_reason_b,
      :result_reason_c => result_reason_c
    }
  end

  def es_each_count(course_survey)
    attend_class_a, attend_class_b, attend_class_c = 0, 0, 0
    interesting_level_a, interesting_level_b, interesting_level_c, interesting_level_d, interesting_level_e = 0, 0, 0, 0, 0
    understand_level_a, understand_level_b, understand_level_c, understand_level_d, understand_level_e = 0, 0, 0, 0, 0

    records = course_survey.course_survey_es_records

    records_group = records.group_by(&:attend_class)
    attend_class_a = records_group['A'].length if !records_group['A'].nil?
    attend_class_b = records_group['B'].length if !records_group['B'].nil?
    attend_class_c = records_group['C'].length if !records_group['C'].nil?

    records_group = records.group_by(&:interesting_level)
    interesting_level_a = records_group['A'].length if !records_group['A'].nil?
    interesting_level_b = records_group['B'].length if !records_group['B'].nil?
    interesting_level_c = records_group['C'].length if !records_group['C'].nil?
    interesting_level_d = records_group['D'].length if !records_group['D'].nil?
    interesting_level_e = records_group['E'].length if !records_group['E'].nil?

    records_group = records.group_by(&:understand_level)
    understand_level_a = records_group['A'].length if !records_group['A'].nil?
    understand_level_b = records_group['B'].length if !records_group['B'].nil?
    understand_level_c = records_group['C'].length if !records_group['C'].nil?
    understand_level_d = records_group['D'].length if !records_group['D'].nil?
    understand_level_e = records_group['E'].length if !records_group['E'].nil?

    {
      :attend_class_a => attend_class_a,
      :attend_class_b => attend_class_b,
      :attend_class_c => attend_class_c,

      :interesting_level_a => interesting_level_a,
      :interesting_level_b => interesting_level_b,
      :interesting_level_c => interesting_level_c,
      :interesting_level_d => interesting_level_d,
      :interesting_level_e => interesting_level_e,

      :understand_level_a => understand_level_a,
      :understand_level_b => understand_level_b,
      :understand_level_c => understand_level_c,
      :understand_level_d => understand_level_d,
      :understand_level_e => understand_level_e
    }
  end


end