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