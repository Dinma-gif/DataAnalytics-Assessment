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

Each file uses Common Table Expressions (CTEs) to break down complex logic into manageable parts, with comments explaining the intent of each step to maintain clarity and ease debugging.


## Query 1: Identify Customers with Funded Savings and Investment Plans
📄 [View SQL](DataAnalytics-Assessment/assessment_question1.sql)

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
📄 [View SQL](DataAnalytics-Assessment/assessment_question2.sql)

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
📄 [View SQL](DataAnalytics-Assessment/assessment_question3.sql)

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
📄 [View SQL](DataAnalytics-Assessment/assessment_question4.sql)

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




