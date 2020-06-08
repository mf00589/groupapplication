require "application_system_test_case"

class ContestsTest < ApplicationSystemTestCase
  setup do
    @contest = contests(:one)
  end

  test "visiting the index" do
    visit contests_url
    assert_selector "h1", text: "Contests"
  end

  test "creating a Contest" do
    visit contests_url
    click_on "New Contest"

    fill_in "Category", with: @contest.category
    fill_in "Description", with: @contest.description
    fill_in "Ending date", with: @contest.ending_date
    check "Is student only" if @contest.is_student_only
    fill_in "Name", with: @contest.name
    fill_in "Payout amount", with: @contest.payout_amount
    fill_in "Skills", with: @contest.skills
    fill_in "Start date", with: @contest.start_date
    fill_in "Vendorid", with: @contest.vendorid
    fill_in "Youtube link", with: @contest.youtube_link
    click_on "Create Contest"

    assert_text "Contest was successfully created"
    click_on "Back"
  end

  test "updating a Contest" do
    visit contests_url
    click_on "Edit", match: :first

    fill_in "Category", with: @contest.category
    fill_in "Description", with: @contest.description
    fill_in "Ending date", with: @contest.ending_date
    check "Is student only" if @contest.is_student_only
    fill_in "Name", with: @contest.name
    fill_in "Payout amount", with: @contest.payout_amount
    fill_in "Skills", with: @contest.skills
    fill_in "Start date", with: @contest.start_date
    fill_in "Vendorid", with: @contest.vendorid
    fill_in "Youtube link", with: @contest.youtube_link
    click_on "Update Contest"

    assert_text "Contest was successfully updated"
    click_on "Back"
  end

  test "destroying a Contest" do
    visit contests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contest was successfully destroyed"
  end
end
