require "application_system_test_case"

class ComplaintsTest < ApplicationSystemTestCase
  setup do
    @complaint = complaints(:one)
  end

  test "visiting the index" do
    visit complaints_url
    assert_selector "h1", text: "Complaints"
  end

  test "should create complaint" do
    visit complaints_url
    click_on "New complaint"

    fill_in "Company", with: @complaint.company
    fill_in "Company public response", with: @complaint.company_public_response
    fill_in "Company response", with: @complaint.company_response
    fill_in "Complain what happened", with: @complaint.complain_what_happened
    fill_in "Complaint", with: @complaint.complaint_id
    fill_in "Consumer consent provided", with: @complaint.consumer_consent_provided
    fill_in "Consumer disputed", with: @complaint.consumer_disputed
    fill_in "Date received", with: @complaint.date_received
    fill_in "Issue", with: @complaint.issue
    fill_in "Product", with: @complaint.product
    fill_in "State", with: @complaint.state
    fill_in "Sub issue", with: @complaint.sub_issue
    fill_in "Sub product", with: @complaint.sub_product
    fill_in "Submitted via", with: @complaint.submitted_via
    fill_in "Tags", with: @complaint.tags
    fill_in "Timely", with: @complaint.timely
    fill_in "Zip code", with: @complaint.zip_code
    click_on "Create Complaint"

    assert_text "Complaint was successfully created"
    click_on "Back"
  end

  test "should update Complaint" do
    visit complaint_url(@complaint)
    click_on "Edit this complaint", match: :first

    fill_in "Company", with: @complaint.company
    fill_in "Company public response", with: @complaint.company_public_response
    fill_in "Company response", with: @complaint.company_response
    fill_in "Complain what happened", with: @complaint.complain_what_happened
    fill_in "Complaint", with: @complaint.complaint_id
    fill_in "Consumer consent provided", with: @complaint.consumer_consent_provided
    fill_in "Consumer disputed", with: @complaint.consumer_disputed
    fill_in "Date received", with: @complaint.date_received.to_s
    fill_in "Issue", with: @complaint.issue
    fill_in "Product", with: @complaint.product
    fill_in "State", with: @complaint.state
    fill_in "Sub issue", with: @complaint.sub_issue
    fill_in "Sub product", with: @complaint.sub_product
    fill_in "Submitted via", with: @complaint.submitted_via
    fill_in "Tags", with: @complaint.tags
    fill_in "Timely", with: @complaint.timely
    fill_in "Zip code", with: @complaint.zip_code
    click_on "Update Complaint"

    assert_text "Complaint was successfully updated"
    click_on "Back"
  end

  test "should destroy Complaint" do
    visit complaint_url(@complaint)
    click_on "Destroy this complaint", match: :first

    assert_text "Complaint was successfully destroyed"
  end
end
