class ComplaintsController < ApplicationController
  before_action :set_complaint, only: [:show, :edit, :update, :destroy]

  def index
    @complaints = Complaint.where(is_user_created: true)
  end

  def show
    rag_pipeline = RagPipeline.new
    @similar_complaints = rag_pipeline.find_similar_complaints(@complaint.embedding)
                                      .reject { |c| c.id == @complaint.id }
                                      .first(4)  # Limit to 4 similar complaints

    # Generate GPT response if it doesn't exist
    if @complaint.gpt_response.nil?
      @gpt_response = generate_gpt_response(@complaint, @similar_complaints)
      @complaint.update(gpt_response: @gpt_response)
    else
      @gpt_response = @complaint.gpt_response
    end
  end

  def new
    @complaint = Complaint.new
  end

  def create
    @complaint = Complaint.new(complaint_params)
    @complaint.is_user_created = true

    rag_pipeline = RagPipeline.new
    result = rag_pipeline.process_new_complaint(@complaint)

    if result && @complaint.save
      @similar_complaints = result[:similar_complaints].first(4)
      @gpt_response = generate_gpt_response(@complaint, @similar_complaints)
      @complaint.update(gpt_response: @gpt_response)
      
      redirect_to @complaint, notice: 'Complaint was successfully created and processed.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @complaint.update(complaint_params)
      rag_pipeline = RagPipeline.new
      result = rag_pipeline.process_new_complaint(@complaint)

      if result
        @similar_complaints = result[:similar_complaints].first(4)
        @gpt_response = generate_gpt_response(@complaint, @similar_complaints)
        @complaint.update(gpt_response: @gpt_response)
      end

      redirect_to @complaint, notice: 'Complaint was successfully updated and reprocessed.'
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
    params.require(:complaint).permit(
      :complain_what_happened,
      :product,
      :sub_product,
      :issue,
      :sub_issue,
      :company,
      :state,
      :zip_code
    )
  end

  def generate_gpt_response(complaint, similar_complaints)
    rag_pipeline = RagPipeline.new
    rag_pipeline.generate_gpt_response(complaint, similar_complaints)
  end
end