# app/services/rag_pipeline.rb
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
      # no need to generate embedding since we do it in the model level

      return if complaint.embedding.nil?
      similar_complaints = find_similar_complaints(embedding)
  
      if similar_complaints.any?
        similar_complaint = similar_complaints.first
  
        complaint.update(
          product: similar_complaint.product.presence || complaint.product,
          sub_product: similar_complaint.sub_product.presence || complaint.sub_product,
          zip_code: similar_complaint.zip_code.presence || complaint.zip_code,
          tags: similar_complaint.tags.presence || complaint.tags,
          complaint_id: similar_complaint.complaint_id.presence || complaint.complaint_id,
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
    end
  end