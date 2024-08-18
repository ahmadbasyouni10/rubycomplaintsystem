class CreateComplaints < ActiveRecord::Migration[7.2]
  # put defaults later
  def change
    create_table :complaints do |t|
      t.string :product
      t.text :complain_what_happened
      t.string :issue
      t.string :sub_product
      t.string :zip_code
      t.string :tags
      t.string :complaint_id
      t.string :timely
      t.string :consumer_consent_provided
      t.string :company_response
      t.string :submitted_via
      t.string :company
      t.datetime :date_received
      t.string :state
      t.string :consumer_disputed
      t.text :company_public_response
      t.string :sub_issue

      # time stamp for each record
      t.timestamps
    end
  end
end
