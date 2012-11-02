module CourseSurveyHelper

  def each_count(course_survey)

    records = course_survey.course_survey_records

    re = {}

    [
      :on_off_class,
      :checking_institution,
      :class_order,
      :prepare_situation,
      :teaching_level,
      :teacher_morality,
      :class_content,
      :knowledge_level,
      :teaching_schedule,
      :teaching_interact,
      :board_writing_quality,
      :has_courseware,
      :courseware_quality,
      :speak_level,
      :study_result,
      :teaching_result,
      :result_reason
    ].each do |stat_key|
      hash = records.group_by {|record| record.send(stat_key)}
      ['A', 'B', 'C'].each {|key| hash[key] ||= []}

      re[stat_key] = hash
    end

    re
  end



  def es_each_count(course_survey)

    records = course_survey.course_survey_es_records

    re = {}

    [
      :attend_class,
      :interesting_level,
      :understand_level
    ].each do |stat_key|
      hash = records.group_by {|record| record.send(stat_key)}
      ['A', 'B', 'C', 'D', 'E'].each {|key| hash[key] ||= []}

      re[stat_key] = hash
    end

    re
  end


  def list_resource_path_for(survey)
    kind = survey.kind
    record = (kind == '1' ? survey.course_survey_records : survey.course_survey_es_records)[0]
    return survey if current_user.is_teacher?
    return edit_course_survey_record_path(record, :kind => kind) if current_user.has_surveyed?(survey)
    new_course_survey_course_survey_record_path(survey, :kind => kind)
  end

end
