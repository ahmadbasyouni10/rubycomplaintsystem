class ComplaintsController < ApplicationController
  before_action :set_complaint, only: [:show, :edit, :update, destroy]

  def index
    # only show user created complaints
    @complaints = Complaint.where(is_user_created: true)
  end

  def show
  end

  def new
    @complaint = Complaint.new
  end

  def create
    @complaint = Complaint.new(complaint_params)
    # set is_user_created to true
    @complaint.is_user_created = true

    if @complaint.save
      redirect_to @complaint, notice: 'Complaint was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @complaint.update(complaint_params)
      redirect_to @complaint, notice: 'Complaint was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @complaint.destroy
    redirect_to complaints_url, notice: 'Complaint was successfully destroyed.'
  end

  private

  def set_complaint
    @complaint = Complaint.where(is_user_created: true).find(params[:id])
  end

  def complaint_params
    params.require(:complaint).permit(:product, :complain_what_happened, :issue, :sub_product, :zip_code, :tags, :timely, :consumer_consent_provided, :company_response, :submitted_via, :company, :date_received, :state, :consumer_disputed, :company_public_response, :sub_issue)
  end
end