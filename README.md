# Restaurant-Consumer-SQL-Data-Analysis-Project.
This SQL project manages data on consumers, restaurants, ratings, and preferences. It demonstrates advanced SQL concepts like joins, CTEs, views, and stored procedures to analyze consumer behavior, spending habits, cuisine preferences, and restaurant performance through practical and efficient data analysis.

# 🍽️ Restaurant & Consumer Data SQL Project

## 📖 Overview
This project analyzes restaurant and consumer data using SQL. It demonstrates how to create a relational database, manage relationships between entities, and extract valuable insights about consumer behavior, restaurant performance, and spending segments using advanced SQL techniques.

## 🧱 Database Structure
The project is built using multiple interrelated tables:
- **Consumers** – Contains demographic and lifestyle details of each consumer.
- **Restaurants** – Stores restaurant information including location, price level, and services.
- **Restaurant_Cuisine** – Links restaurants with their offered cuisines.
- **Consumer_Preferences** – Shows preferred cuisines for each consumer.
- **Ratings** – Records overall, food, and service ratings given by consumers.

## ⚙️ Key SQL Concepts Used
- **Database & Table Creation**
- **WHERE Clauses** for filtering data
- **JOINS & Subqueries**
- **GROUP BY & HAVING Clauses**
- **CTEs (Common Table Expressions)**
- **Window Functions** (RANK, ROW_NUMBER, DENSE_RANK)
- **Views** for reusable queries
- **Stored Procedures** for automation and analysis

## 🧠 Analysis Highlights
- Identify top-rated restaurants by cuisine type.
- Analyze consumer segments based on spending behavior.
- Rank restaurants based on average ratings.
- Use window functions to find rating patterns.
- Create stored procedures for automated insights.

## 💡 Example Insights
- Top 2 highest-rated restaurants for each cuisine.
- Consumers who prefer “Mexican” cuisine but haven’t rated highly rated Mexican restaurants.
- Spending segment classification such as *Budget Conscious*, *Moderate Spender*, and *Premium Spender*.

## 🗂️ Files Included
- SQL Script: `Restaurant_Consumer_Project.sql`
- Documentation: `Restaurant & Consumer Data Project.pdf`
- (Optional) Presentation: `Project_Presentation.pptx`

## 🚀 How to Run
1. Install **MySQL 8+** (or MariaDB).
2. Create a database:
   ```sql
        CREATE DATABASE PROJECT;
        USE PROJECT;
3. Copy and run the script from **'RESTAURANT AND CONSUMER ANALYSIS.sql'** into your SQL client (MySQL 8+ recommended).
4. Explore queries step by step:
   - **Section A**: Basic filters ('WHERE')
   - **Section B**: Joins & Subqueries
   - **Section C**: Aggregations & Order of Execution ('GROUP BY', 'HAVING')
   - **Section D**: Advanced SQL (CTEs, Window Functions, Views, Stored Procedures)


## 🏁 Conclusion
This project provides a complete learning experience in SQL — from database creation to advanced analytics using joins, CTEs, and stored procedures. It’s ideal for mastering SQL concepts through real-world restaurant and consumer data.
