# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Developing notes:

- Default sqlite3 database unless specified.
- Ruby on rails is MVC based
 1: Model which has logic for interacting with the db lives, models represent the data and responsible for communicating with db
 - Complaint model will have attributes like complainttext, date, user, company, etc
 - Controller will handle requests and logic, pass view fetch data from model
 -View what user sees

 - RAG and Data Augmentation - provide additional context to LLM to improve response, provide data to make it specific to a company

 - Langchain is a framework that helps integrate LLMs and databases build apps, agents are components that decide what actions to take based on user input. Used to integrate OpenAI and pgvector. Decide whether to use RAG pipeline or no

 -Migrate is powered by DSL domain specific language no need for SQL by hand

 -vector extension is now enabled in your PostgreSQL database. This allows your database to support vector-based operations, which are essential for your RAG (Retrieval-Augmented Generation) pipeline.

 -embedding column has been added to your complaints table. This column will store the vector embeddings for each complaint, allowing you to efficiently retrieve and compare related complaints based on similarity.

 - switched to Postgresql db, go through docker and understand it

 RAG Pipeline:
Step 1: Embedding Generation:

When a new complaint is submitted, you generate an embedding (a vector representation) of the complaint text using an AI model (like OpenAI’s GPT model).
This embedding is stored in your vector database (or in a vector column in PostgreSQL if you're using pgvector).
Step 2: Retrieval:

When processing a new query or complaint, the RAG pipeline retrieves similar complaints by comparing embeddings.
The vector database quickly identifies complaints that are closest in meaning to the new one.
Step 3: Augmented Generation:

The AI model (GPT) uses the context of the retrieved complaints to generate a response.
For example, if the system retrieves complaints similar to the new one, the model might use this context to categorize the new complaint (filling in fields like product and sub-product) or to generate a summary/response.