require "test_helper"

class Admin::AboutControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get admin_about_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_about_update_url
    assert_response :success
  end
end
