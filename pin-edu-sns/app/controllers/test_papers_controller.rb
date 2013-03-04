class TestPapersController < ApplicationController
  def create
    if current_user.is_student?
      plan = TeachingPlan.find(params[:teaching_plan_id])
      test_paper = plan.make_test_paper_for(current_user)
      redirect_to test_paper_path(test_paper)
    end
  end

  def show
    @test_paper = TestPaper.find(params[:id])
  end
end
