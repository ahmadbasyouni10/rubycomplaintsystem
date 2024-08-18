class AddVectorColumnToComplaints < ActiveRecord::Migration[7.2]
  def change
    add_column :complaints, :embedding, :vector,
      limit: LangchainrbRails
        .config
        .vectorsearch
        .llm
        .default_dimensions
  end
end
