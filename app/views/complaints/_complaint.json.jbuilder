json.extract! complaint, :id, :product, :complain_what_happened, :issue, :sub_product, :zip_code, :tags, :complaint_id, :timely, :consumer_consent_provided, :company_response, :submitted_via, :company, :date_received, :state, :consumer_disputed, :company_public_response, :sub_issue, :created_at, :updated_at
json.url complaint_url(complaint, format: :json)
