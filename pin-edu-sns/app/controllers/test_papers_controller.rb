class TestPapersController < ApplicationController
  def create
    plan = TeachingPlan.find(params[:teaching_plan_id])
    test_paper = plan.make_test_paper
    redirect_to test_paper_path(test_paper)
  end

  def show
    @test_paper = TestPaper.find(params[:id])
  end
end
