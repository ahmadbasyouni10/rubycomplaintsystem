namespace :import do
  desc "Import complaints from JSON with embeddings"
  task complaints: :environment do
    file_path = Rails.root.join('db', 'complaints_data.json')
    complaint_data = JSON.parse(File.read(file_path))

    batch_size = 200
    cool_down_time = 10
    total_complaints = complaint_data.size
    processed_complaints = 0
    failed_complaints = 0

    complaint_data.each_slice(batch_size).with_index do |batch, index|
      start = index * batch_size
      puts "Processing batch #{index + 1}/#{(total_complaints.to_f / batch_size).ceil} (complaints #{start + 1}-#{[start + batch_size, total_complaints].min})"

      ActiveRecord::Base.transaction do
        batch.each do |complaint_hash|
          begin
            complaint_source = complaint_hash['_source']

            embedding = RagPipeline.new.generate_embedding(complaint_source['complaint_what_happened'])

            complaint = Complaint.create!(
              product: complaint_source['product'].to_s,
              complain_what_happened: complaint_source['complaint_what_happened'].to_s,
              issue: complaint_source['issue'].to_s,
              sub_product: complaint_source['sub_product'].to_s,
              zip_code: complaint_source['zip_code'].to_s,
              tags: complaint_source['tags'].is_a?(Array) ? complaint_source['tags'].join(', ') : complaint_source['tags'].to_s,
              complaint_id: complaint_source['complaint_id'],
              timely: complaint_source['timely'].to_s,
              consumer_consent_provided: complaint_source['consumer_consent_provided'].to_s,
              company_response: complaint_source['company_response'].to_s,
              submitted_via: complaint_source['submitted_via'].to_s,
              company: complaint_source['company'].to_s,
              date_received: complaint_source['date_received'],
              state: complaint_source['state'].to_s,
              consumer_disputed: complaint_source['consumer_disputed'].to_s,
              company_public_response: complaint_source['company_public_response'].to_s,
              sub_issue: complaint_source['sub_issue'].to_s,
              is_user_created: false,
              embedding: embedding
            )

            processed_complaints += 1
            puts "Created complaint with ID: #{complaint.id}" if processed_complaints % 10 == 0
          rescue StandardError => e
            failed_complaints += 1
            puts "Error processing complaint: #{e.message}"
          end
        end
      end

      puts "Completed batch #{index + 1}. Total complaints processed: #{processed_complaints}, Failed: #{failed_complaints}"
      sleep(cool_down_time)
    end

    puts "Import completed. Total complaints in database: #{Complaint.count}"
    puts "Processed: #{processed_complaints}, Failed: #{failed_complaints}"
  end
end