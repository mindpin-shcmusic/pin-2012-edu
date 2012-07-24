module SharedExamples
  shared_examples 'a academical organization form' do |model|
    describe '#get_user_ids' do
      it 'should return all participating user ids' do
        org_form = send("make_a_#{model}", 4)
        users = [org_form.teacher, org_form.students].flatten.map(&:user_id).sort

        org_form.get_user_ids.should eq users
      end
    end
  end

  shared_examples 'user participated academical organization forms collection' do |model|
    describe "##{model.to_s.pluralize}" do
      it "should return all this users who is participating this #{model} as teacher or student" do
        org_form = send("make_a_#{model}", 4)

        teacher_user = org_form.teacher.user
        student_user = org_form.students[0].user

        [teacher_user, student_user].each do |user|
          user.send(model.to_s.pluralize).should include org_form
        end
      end
    end
  end

end
