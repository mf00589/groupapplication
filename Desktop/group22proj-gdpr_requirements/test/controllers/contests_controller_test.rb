require 'test_helper'

class ContestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contest = contests(:one)
  end

  test "should get index" do
    get contests_url
    assert_response :success
  end

  test "should get new" do
    get new_contest_url
    assert_response :success
  end

  test "should create contest" do
    assert_difference('Contest.count') do
      post contests_url, params: { contest: { category: @contest.category, description: @contest.description, ending_date: @contest.ending_date, is_student_only: @contest.is_student_only, name: @contest.name, payout_amount: @contest.payout_amount, skills: @contest.skills, start_date: @contest.start_date, vendorid: @contest.vendorid, youtube_link: @contest.youtube_link } }
    end

    assert_redirected_to contest_url(Contest.last)
  end

  test "should show contest" do
    get contest_url(@contest)
    assert_response :success
  end

  test "should get edit" do
    get edit_contest_url(@contest)
    assert_response :success
  end

  test "should update contest" do
    patch contest_url(@contest), params: { contest: { category: @contest.category, description: @contest.description, ending_date: @contest.ending_date, is_student_only: @contest.is_student_only, name: @contest.name, payout_amount: @contest.payout_amount, skills: @contest.skills, start_date: @contest.start_date, vendorid: @contest.vendorid, youtube_link: @contest.youtube_link } }
    assert_redirected_to contest_url(@contest)
  end

  test "should destroy contest" do
    assert_difference('Contest.count', -1) do
      delete contest_url(@contest)
    end

    assert_redirected_to contests_url
  end
end
