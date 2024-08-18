class AddGptResponseToComplaints < ActiveRecord::Migration[7.2]
  def change
    add_column :complaints, :gpt_response, :text
  end
end
