require 'test_helper'

class Api::V1::SchoolsControllerTest < ActionDispatch::IntegrationTest
  test "test_schools_are_created" do
    assert_equal 2, School.count
  end
end
