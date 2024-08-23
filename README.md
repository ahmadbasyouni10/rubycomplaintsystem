# Ruby Complaint System

This application is designed to manage and process user complaints using Ruby on Rails. It leverages modern technologies such as PostgreSQL with vector extensions and Langchain to enhance complaint management through AI-driven insights.

# System Architecture
![image](https://github.com/user-attachments/assets/4504663f-7103-4cc6-828a-b4671cc5add7)


## Table of Contents

- [Ruby Version](#ruby-version)
- [System Dependencies](#system-dependencies)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Test Suite](#running-the-test-suite)
- [Deployment Instructions](#deployment-instructions)
- [RAG Pipeline Overview](#rag-pipeline-overview)
- [Developing Notes](#developing-notes)

## Ruby Version

The application is developed using Ruby on Rails. Ensure you have the correct Ruby version specified in the `Gemfile`.

## System Dependencies

- PostgreSQL with vector extension enabled (`pgvector`).
- OpenAI API for embedding generation.
- Docker (optional but recommended for consistent development environments).

## Configuration

- Clone the repository and run `bundle install` to install the necessary gems.
- Set up environment variables for the OpenAI API and database configuration.
- Adjust configurations in `config/database.yml` for your database setup.

## Database Setup

1. **Database Creation:**
   - Run `rails db:create` to create the database.

2. **Database Initialization:**
   - Run `rails db:migrate` to apply all migrations.
   - The database is set up to use PostgreSQL with a vector extension (`pgvector`) to support vector-based operations.

## Running the Test Suite

- Run `rails test` to execute the test suite and ensure everything is working as expected.

## Deployment Instructions

- To deploy the application, follow standard Rails deployment practices, ensuring the PostgreSQL database is properly configured with the `pgvector` extension.

## RAG Pipeline Overview

### Step 1: Embedding Generation

- When a new complaint is submitted, an embedding (a vector representation) is generated using an AI model (e.g., OpenAI’s GPT model).
- This embedding is stored in the database within a vector column, allowing efficient retrieval and comparison of similar complaints.

### Step 2: Retrieval

- The RAG pipeline retrieves similar complaints by comparing embeddings, identifying those closest in meaning to the new one.

### Step 3: Augmented Generation

- The AI model uses the context of retrieved complaints to generate responses, categorize new complaints, or fill in fields like product and sub-product.

## Developing Notes

- **MVC Structure**: Ruby on Rails follows the MVC (Model-View-Controller) pattern:
  1. **Model**: Interacts with the database and represents data (e.g., `Complaint` model).
  2. **Controller**: Handles requests, fetches data from models, and renders views (e.g., `ComplaintsController`).
  3. **View**: What the user sees in the browser.

- **Database**: Initially set up with SQLite3 but switched to PostgreSQL for better scalability and vector support. The `pgvector` gem is used for storing and querying vector data like embeddings.

- **Langchain Framework**: Used to integrate LLMs (Large Language Models) and databases. Langchain facilitates building applications that require AI-driven insights and is planned for use to handle flexible abstraction and embedding strategies.

- **Batch Processing**: Increased the batch size to 1,000 records per batch during import to reduce transaction overhead and improve performance.

- **Rake Tasks**: Custom Rake tasks are used to manage data imports, including embedding generation on the fly using the `RagPipeline`.

- **Future Considerations**: Langchain will be considered for handling API integrations and flexible embedding strategies, providing an abstraction layer over the embedding process.
