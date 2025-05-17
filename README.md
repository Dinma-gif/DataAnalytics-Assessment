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

## 💡 Approach & Challenges

### Thought Process

For each question, I prioritized writing clear, modular SQL that is easy to understand and maintain. I chose to use CTEs extensively to isolate logical steps such as filtering relevant users, aggregating transactions, or calculating date differences. This approach made debugging and testing easier.

I also made sure to consistently convert monetary amounts from kobo (smallest currency unit in the dataset) to naira, as this reflects realistic currency units for financial analysis.

### Challenges Faced

- **Date and Interval Handling:** AWS RDS PostgreSQL required specific syntax for date difference calculations (`DATEDIFF` isn’t native). I adapted by using `DATE_PART` and arithmetic expressions to get accurate tenure and inactivity durations.  
- **Joins on Large Tables:** Some tables had millions of rows, so I carefully filtered early in CTEs to reduce dataset size before joins, which improved performance noticeably.  
- **Null and Zero Values:** To avoid errors like division by zero and to keep calculations meaningful, I added safeguards with `COALESCE` and `HAVING` clauses to exclude irrelevant rows.

### Performance Optimization

- Used `INNER JOIN` instead of `LEFT JOIN` when I wanted to ensure existence of both savings and investment plans, avoiding unnecessary rows.  
- Aggregated counts and sums in grouped CTEs to reduce the amount of data handled downstream.  
- Indexed key columns (in the source database) such as `owner_id` and `plan_id` to speed up join operations (outside the scope of SQL scripts, but noted for production environments).

---



