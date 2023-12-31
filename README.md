# Udiddit-Database-Schema-Design-Project

## Project Description

Revamping Udiddit: Enhancing Database Reliability and Efficiency - This project involves overhauling Udiddit's existing Postgres database schema, which currently presents risks and unreliability in storing forum posts, discussions, and user votes on various topics. The focus is on designing a new, robust schema, addressing existing issues, and seamlessly migrating data to the improved system, thereby enhancing overall data integrity and performance.

Part I: Investigate the existing schema
Part II: Create the DDL for your new schema
Part III: Migrate the provided data

## Dataset Info

bad_db.sql: A File Containing Suboptimal Database Schema for Revamping - This file houses the existing database schema, identified as requiring comprehensive enhancements. It serves as the foundation for my project to redesign and optimize the database structure

## Languages & Tools used 

PostgreSQL


## Old Database Schema

Current Schema Design and Identified Issues - The following outlines the design of the existing schema. It highlights several critical issues that need to be addressed.

1.	Foreign keys are currently not established between the tables. It is recommended to define the "post_id" in the "bad_comments" table as a foreign key to explicitly indicate the association between "bad_comments" and "bad_posts."
2.	Further normalization is advisable for this schema. Consider decomposing the columns in the "bad_posts" table into smaller tables, specifically separating data into tables for 'title' and 'topic.'
3.	The "upvotes" and "downvotes" columns in the "bad_posts" table contain multiple values per row. To adhere to the First Normal Form, it is essential to reorganize this structure.
4.	Enhance search performance by creating an index on the "username" column for both tables. This indexing will significantly improve the efficiency of search operations.
5.	Employ the unique constraint for the "username" column in the "users" table to prevent the occurrence of duplicate entries. This ensures data integrity and avoids redundancy.


![alt text](https://github.com/jwoh1323/Udiddit-SQL-Schema-Design-Project/blob/a10929cc10171806740e9dab740f489030f53d40/old%20schema.png) 

## New Database Schema

1. Implement foreign key constraints in the database schema.
2. Break down the "bad_posts" and "bad_posts" table into smaller, more focused tables. Create separate tables for 'users','topics', and 'votes', and establish relationships with the main posts table.
3. Instead of storing multiple values in a single row, create separate tables for 'upvotes' and 'downvotes'. Each row in these tables should represent a single vote (1,-1), linked to the respective post, thereby maintaining atomicity of data.
4. Create indexes on columns. Indexing the columns will expedite search queries.
5. Apply a unique constraint to the columns in the "users" table. This constraint prevents the insertion of duplicate usernames, thus maintaining data uniqueness and integrity. 

![alt text](https://github.com/jwoh1323/Udiddit-SQL-Schema-Design-Project/blob/5f6abc763b190c4ef45442f70706208e309eb51c/new%20schema.png) 


## Project Output

This [report](https://github.com/jwoh1323/Udiddit-SQL-Schema-Design-Project/blob/4f3a13ca9ae80d4728552fb1f9d06c63bfdf9bea/udiddit-a-social-news-aggregator-Jinwoo.pdf) details the queries utilized for designing the new schema and outlines the process for migrating data to the newly established schema
