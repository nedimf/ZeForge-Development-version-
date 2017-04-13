require 'test_helper'

class ClassroomControllerTest < ActionDispatch::IntegrationTest
  test "should get library" do
    get classroom_library_url
    assert_response :success
  end

end
