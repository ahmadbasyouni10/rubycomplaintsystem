# frozen_string_literal: true
# for later use, use langchain for vector search similarity and embedding generating
LangchainrbRails.configure do |config|
  config.vectorsearch = Langchain::Vectorsearch::Pgvector.new(
    llm: Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
  )
end
