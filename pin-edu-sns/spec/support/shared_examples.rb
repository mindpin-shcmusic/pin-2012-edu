module SharedExamples
  shared_examples 'a academical organization form' do |unit, student_num|
    describe '#get_user_ids' do
      it 'should return all participating user ids' do
        org_form = eval("make_a_#{unit}(#{student_num})")
        users = [org_form.teacher, org_form.students].flatten.map(&:user_id).sort

        org_form.get_user_ids.should eq users
      end
    end
  end
end
