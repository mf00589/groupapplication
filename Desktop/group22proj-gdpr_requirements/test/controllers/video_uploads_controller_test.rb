require 'test_helper'

class VideoUploadsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get video_uploads_new_url
    assert_response :success
  end

  test "should get create" do
    get video_uploads_create_url
    assert_response :success
  end

end
