require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:canaan)
  end

  test 'should get index' do
    get users_path
    assert_response :see_other
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end
  # added test
  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :see_other
  end
  # test for delete
  # test 'should destroy user' do
  #   assert_difference('User.count', -1) do
  #     delete user_url(@user)
  #   end

  #   assert_redirected_to users_url
  # end
end
