class RagPipeline
  # constructor initializes instance of openai client
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def generate_embedding(text)
    return nil if text.blank?
    Rails.logger.info("Generating embedding for text: #{text.inspect}")
    begin
      response = @client.embeddings(
        parameters: {
          model: 'text-embedding-ada-002',
          input: text
        }
      )
      # dig used to access nested hash values, take 0 index of data array which contains the embedding
      embedding = response.dig("data", 0, "embedding")
      Rails.logger.info("Generated embedding: #{embedding.inspect}")
      embedding
    # Faraday is for handling HTTP requests and responses
    rescue Faraday::BadRequestError => e
      Rails.logger.error("Bad request: #{e.message}")
      nil
    end
  end

  def find_similar_complaints(embedding)
    return [] if embedding.nil?
    
    # select all complaints where embedding is not nil, order by distance between embeddings
    Complaint.where.not(embedding: nil)
             .order(Arel.sql("embedding <-> ARRAY[#{embedding.join(',')}]::vector"))
             .limit(5)
  end

  def classify_and_categorize(complaint)
    # Return the complaint if embedding is nil
    return complaint if complaint.embedding.nil?
    similar_complaints = find_similar_complaints(complaint.embedding)

    if similar_complaints.any?
      similar_complaint = similar_complaints.first

      # Use assign_attributes instead of update to allow for review before saving
      complaint.assign_attributes(
        product: similar_complaint.product.presence || complaint.product,
        sub_product: similar_complaint.sub_product.presence || complaint.sub_product,
        zip_code: similar_complaint.zip_code.presence || complaint.zip_code,
        tags: similar_complaint.tags.presence || complaint.tags,
        timely: similar_complaint.timely.presence || complaint.timely,
        consumer_consent_provided: similar_complaint.consumer_consent_provided.presence || complaint.consumer_consent_provided,
        company_response: similar_complaint.company_response.presence || complaint.company_response,
        submitted_via: similar_complaint.submitted_via.presence || complaint.submitted_via,
        company: similar_complaint.company.presence || complaint.company,
        date_received: similar_complaint.date_received.presence || complaint.date_received,
        state: similar_complaint.state.presence || complaint.state,
        consumer_disputed: similar_complaint.consumer_disputed.presence || complaint.consumer_disputed,
        company_public_response: similar_complaint.company_public_response.presence || complaint.company_public_response,
        sub_issue: similar_complaint.sub_issue.presence || complaint.sub_issue
      )
    end

    complaint
  end

  # Generate GPT response based on the complaint and similar complaints
  def generate_gpt_response(complaint, similar_complaints)
    context = similar_complaints.map { |c| "#{c.product}: #{c.complain_what_happened}" }.join("\n\n")
    prompt = "Given the following context of similar complaints:\n\n#{context}\n\nAnd the current complaint:\n#{complaint.complain_what_happened}\n\nProvide a helpful response addressing the complaint and suggesting next steps."

    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 150
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  # Process a new complaint: generate embedding, find similar complaints, classify, and generate GPT response
  def process_new_complaint(complaint)
    embedding = generate_embedding(complaint.complain_what_happened)
    return nil if embedding.nil?

    complaint.embedding = embedding
    similar_complaints = find_similar_complaints(embedding)
    
    classified_complaint = classify_and_categorize(complaint)
    gpt_response = generate_gpt_response(classified_complaint, similar_complaints)

    {
      complaint: classified_complaint,
      gpt_response: gpt_response,
      similar_complaints: similar_complaints
    }
  end
end