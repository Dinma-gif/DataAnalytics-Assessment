# Cowrywise Data Analytics Assessment

This repository presents a comprehensive response to the Cowrywise Data Analytics Assessment. It includes SQL-based solutions to four analytical business questions, with each query designed to be efficient, scalable, and clearly interpretable.

In alignment with best practices, sample data was ingested, modeled, and queried using Amazon Web Services (AWS), ensuring cloud-scale reproducibility and performance.

---

## 🔍 Overview

- **Cloud Environment**: Data was staged and queried via **Amazon RDS (PostgreSQL)**, ensuring real-world relevance and compatibility with production-scale SQL operations.
- **Structure**: Each `.sql` file is modular, self-contained, and scoped to a single question. Complex logic is explained through inline comments, and queries are optimized for readability and performance.
- **Objective**: Go beyond simply writing queries — demonstrate analytical reasoning, data modeling skills, and the ability to surface meaningful insights from structured datasets.

---

## 📁 Repository Structure

- `assessment_question1.sql` —  
  Identifies customers who have **at least one funded savings plan and one funded investment plan**. I aggregated counts and total deposits (converted from kobo to naira) for each user. The approach involved joining user profiles with filtered savings and investment accounts to isolate only those fully funded plans, ensuring meaningful inclusion.

- `assessment_question2.sql` —  
  Analyzes **transaction frequency per customer**, classifying users into High, Medium, or Low frequency groups based on their average monthly transactions. I calculated tenure in months and total transactions, then derived the transaction rate per month before categorization. This helps understand customer engagement levels quantitatively.

- `assessment_question3.sql` —  
  Flags customers with accounts **inactive for over 365 days**, based on the date of their latest inflow transaction. The query finds the most recent deposit per customer and filters those with no activity for over a year, which could signal churn risk or dormancy. This analysis is crucial for targeted retention efforts.

- `assessment_question4.sql` —  
  Estimates **Customer Lifetime Value (CLV)** using a simplified profit model based on tenure, total transactions, and total transaction amounts. I carefully handled cases with zero or null values to avoid skewed calculations, converting amounts into naira and projecting annualized transaction revenue. This provides a data-driven estimate of customer value over time.

Each file uses Common Table Expressions (CTEs) to break down complex logic into manageable parts, with comments explaining the intent of each step to maintain clarity and ease debugging.

---

# SQL Queries Analysis & Explanation

This repository contains four SQL queries designed to analyze customer savings and investment data. Each query addresses a specific business question, leveraging common table expressions (CTEs) for modular, readable logic.

---

## Query 1: Identify Customers with Funded Savings and Investment Plans

### Approach
- Extract user details with normalized names (capitalized, defaulting to 'Unknown' if absent).
- Aggregate savings and investment accounts separately:
  - Count distinct plans per user.
  - Sum confirmed deposits (only funded plans with deposits > 0).
- Join these aggregates to find users having **at least one funded savings plan and one funded investment plan**.
- Calculate total deposits in Nigerian Naira (converting from kobo) and present results ordered by deposit amount.

### Challenges
- Handling users with missing or null names: used `coalesce` and `nullif` to generate readable output.
- Ensuring deposits summed only positive confirmed amounts.
- Correct conversion from kobo to naira, with rounding to two decimals.

---

## Query 2: Customer Transaction Frequency Categorization

### Approach
- Calculate monthly transaction counts per customer using `date_trunc` for month grouping.
- Compute average monthly transactions per customer.
- Categorize customers into **High, Medium, and Low frequency** based on thresholds (>=10, 3–9, <3 transactions).
- Aggregate customer counts and average transaction rates per category for reporting.

### Challenges
- Grouping transactions by month efficiently.
- Defining meaningful frequency categories for customer segmentation.
- Ensuring averages correctly reflect the monthly transaction behavior over the period.

---

## Query 3: Detect Inactive Plans Over 365 Days

### Approach
- Determine the latest inflow transaction per plan (savings or investment) for active users.
- Filter plans where the latest transaction was more than 365 days ago.
- Classify plans as Savings or Investment based on plan attributes.
- Calculate days of inactivity for monitoring purposes.

### Challenges
- Accurately identifying the latest positive transaction per plan.
- Handling multiple plan types with conditional logic.
- Using date arithmetic to calculate inactivity duration.

---

## Query 4: Estimate Customer Lifetime Value (CLV)

### Approach
- Calculate each customer's tenure in months based on `date_joined`.
- Aggregate total transactions and amounts per customer with tenure >= 1 month.
- Compute an estimated CLV formula that scales average transactions per year by average transaction amount (scaled to thousands).
- Present customers ordered by descending estimated CLV.

### Challenges
- Computing tenure in months (used database-specific date difference function).
- Avoiding division by zero when calculating average transaction amount.
- Combining multiple metrics into a meaningful single CLV estimate.

---

## General Challenges & Resolutions

- **Data Quality:** Missing or null values were handled explicitly using `coalesce` and default values.
- **Date Calculations:** Different date functions and truncation were used to ensure accurate time-based aggregations.
- **Performance:** Use of CTEs allowed breaking down complex queries into manageable parts, improving readability and maintainability.
- **Currency Conversion:** Carefully converted kobo to naira with appropriate rounding to maintain financial accuracy.

---

If you have any questions or need further explanation, feel free to reach out!




