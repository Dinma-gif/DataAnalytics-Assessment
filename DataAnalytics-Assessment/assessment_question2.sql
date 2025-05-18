--  Calculate monthly transactions per customer
WITH monthly_transactions AS (
    SELECT
        sa.owner_id,
        DATE_TRUNC('month', sa.transaction_date) AS month_year,
        COUNT(*) AS transaction_count
    FROM 
        savings_savingsaccount sa
    WHERE
        sa.transaction_date IS NOT NULL
    GROUP BY 
        sa.owner_id, DATE_TRUNC('month', sa.transaction_date)
),

-- Compute average monthly transactions per customer
average_transactions AS (
    SELECT
        u.id AS customer_id,
        u.first_name,
        u.last_name,
        AVG(COALESCE(mt.transaction_count, 0)) AS avg_monthly_transactions
    FROM 
        users_customuser u
    LEFT JOIN 
        monthly_transactions mt ON u.id = mt.owner_id
    GROUP BY 
        u.id, u.first_name, u.last_name
),

-- Step 3: Assign frequency category to each customer
labeled_customers AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        avg_monthly_transactions,
        CASE
            WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'     -- 10+ transactions/month
            WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'   -- 3-9 transactions/month
            ELSE 'Low Frequency'                                         -- <3 transactions/month
        END AS frequency_category
    FROM 
        average_transactions
)

-- Step 4: Aggregate final results by frequency category
SELECT
    frequency_category,
    COUNT(*) AS customer_count,                                 -- Number of customers in each category
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM 
    labeled_customers
GROUP BY 
    frequency_category
ORDER BY 
    -- Custom sort: High > Medium > Low
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
