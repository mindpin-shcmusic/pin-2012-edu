module SharedExamples
  shared_examples 'a academical organization form' do |model|
    describe '#get_user_ids' do
      it 'should return all participating user ids' do
        org_form = FactoryGirl.create model, :with_student_users
        user_ids = (org_form.student_users.unshift org_form.teacher_user).map(&:id).sort

        org_form.get_user_ids.sort.should eq user_ids
      end
    end
  end

  shared_examples 'user participated academical organization forms collection' do |model|
    describe "##{model.to_s.pluralize}" do
      it "should return all this users who is participating this #{model} as teacher or student" do
        org_form = FactoryGirl.create model, :with_student_users

        [org_form.teacher_user, org_form.student_users[0]].each do |user|
          user.send(model.to_s.pluralize).should include org_form
        end
      end
    end
  end

end
