require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  test "should get add_tag" do
    get :add_tag
    assert_response :success
  end

  test "should get edit_tag" do
    get :edit_tag
    assert_response :success
  end

end
