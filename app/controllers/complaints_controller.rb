class ComplaintsController < ApplicationController
  before_action :set_complaint, only: %i[show edit update destroy]

  def index
    @complaints = Complaint.all
  end

  def show
  end

  def new
    @complaint = Complaint.new
  end

  def edit
  end

  def create
    @complaint = Complaint.new(complaint_params)

    if @complaint.save
      redirect_to @complaint, notice: 'Complaint was successfully created and categorized.'
    else
      render :new
    end
  end

  def update
    if @complaint.update(complaint_params)
      redirect_to @complaint, notice: 'Complaint was successfully updated and re-categorized.'
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
    @complaint = Complaint.find(params[:id])
  end

  def complaint_params
    params.require(:complaint).permit(:complain_what_happened)
  end
end