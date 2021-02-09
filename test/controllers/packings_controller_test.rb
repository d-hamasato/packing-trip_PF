require 'test_helper'

class PackingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get packings_new_url
    assert_response :success
  end

  test "should get index" do
    get packings_index_url
    assert_response :success
  end

  test "should get edit" do
    get packings_edit_url
    assert_response :success
  end

  test "should get show" do
    get packings_show_url
    assert_response :success
  end

end
