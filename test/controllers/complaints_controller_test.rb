require "test_helper"

class ComplaintsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @complaint = complaints(:one)
  end

  test "should get index" do
    get complaints_url
    assert_response :success
  end

  test "should get new" do
    get new_complaint_url
    assert_response :success
  end

  test "should create complaint" do
    assert_difference("Complaint.count") do
      post complaints_url, params: { complaint: { company: @complaint.company, company_public_response: @complaint.company_public_response, company_response: @complaint.company_response, complain_what_happened: @complaint.complain_what_happened, complaint_id: @complaint.complaint_id, consumer_consent_provided: @complaint.consumer_consent_provided, consumer_disputed: @complaint.consumer_disputed, date_received: @complaint.date_received, issue: @complaint.issue, product: @complaint.product, state: @complaint.state, sub_issue: @complaint.sub_issue, sub_product: @complaint.sub_product, submitted_via: @complaint.submitted_via, tags: @complaint.tags, timely: @complaint.timely, zip_code: @complaint.zip_code } }
    end

    assert_redirected_to complaint_url(Complaint.last)
  end

  test "should show complaint" do
    get complaint_url(@complaint)
    assert_response :success
  end

  test "should get edit" do
    get edit_complaint_url(@complaint)
    assert_response :success
  end

  test "should update complaint" do
    patch complaint_url(@complaint), params: { complaint: { company: @complaint.company, company_public_response: @complaint.company_public_response, company_response: @complaint.company_response, complain_what_happened: @complaint.complain_what_happened, complaint_id: @complaint.complaint_id, consumer_consent_provided: @complaint.consumer_consent_provided, consumer_disputed: @complaint.consumer_disputed, date_received: @complaint.date_received, issue: @complaint.issue, product: @complaint.product, state: @complaint.state, sub_issue: @complaint.sub_issue, sub_product: @complaint.sub_product, submitted_via: @complaint.submitted_via, tags: @complaint.tags, timely: @complaint.timely, zip_code: @complaint.zip_code } }
    assert_redirected_to complaint_url(@complaint)
  end

  test "should destroy complaint" do
    assert_difference("Complaint.count", -1) do
      delete complaint_url(@complaint)
    end

    assert_redirected_to complaints_url
  end
end
