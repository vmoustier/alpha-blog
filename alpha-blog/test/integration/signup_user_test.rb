require 'test_helper'

class SignupUserTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username: "John", email: "John@example.com", password: "password", admin: true)
  end
  
  test "should be logged in" do
    get login_path
    sign_in_as(@user, "password")
    assert_equal 'You are now login', flash[:success]
    assert_redirected_to user_path(@user)
  end
  
  test "should not be logged in" do
    get login_path
    sign_in_as(@user, "notpassword")
    assert_equal 'Wrong login or password, please try again!', flash[:danger]
    assert_template 'sessions/new'
  end
end