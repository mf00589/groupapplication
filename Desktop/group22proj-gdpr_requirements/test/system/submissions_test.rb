require "application_system_test_case"

class SubmissionsTest < ApplicationSystemTestCase
  setup do
    @submission = submissions(:one)
  end

  test "visiting the live_chat" do
    visit submissions_url
    assert_selector "h1", text: "Submissions"
  end

  test "creating a Submission" do
    visit submissions_url
    click_on "New Submission"

    fill_in "Contestid", with: @submission.contestid
    fill_in "Freelancerid", with: @submission.freelancerid
    fill_in "Ranking", with: @submission.ranking
    fill_in "Share of price", with: @submission.share_of_price
    click_on "Create Submission"

    assert_text "Submission was successfully created"
    click_on "Back"
  end

  test "updating a Submission" do
    visit submissions_url
    click_on "Edit", match: :first

    fill_in "Contestid", with: @submission.contestid
    fill_in "Freelancerid", with: @submission.freelancerid
    fill_in "Ranking", with: @submission.ranking
    fill_in "Share of price", with: @submission.share_of_price
    click_on "Update Submission"

    assert_text "Submission was successfully updated"
    click_on "Back"
  end

  test "destroying a Submission" do
    visit submissions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Submission was successfully destroyed"
  end
end
