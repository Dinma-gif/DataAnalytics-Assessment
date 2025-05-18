
WITH
    -- Calculate the total number of transactions per customer per month
    monthly_transactions AS (
        SELECT
            owner_id,
            DATE_TRUNC('month', transaction_date) AS month_year,
            COUNT(*) AS transaction_count
        FROM 
            savings_savingsaccount
        GROUP BY 
            owner_id, DATE_TRUNC('month', transaction_date)
        -- Using DATE_TRUNC directly in GROUP BY ensures consistency with the SELECT expression
    ),
    
    -- Calculate average monthly transactions for each customer and assign them to appropriate frequency categories

    customer_avg_transactions AS (
        SELECT
            owner_id,
            AVG(transaction_count) AS avg_monthly_transactions,
            CASE
                WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'    -- 10+ transactions per month
                WHEN AVG(transaction_count) >= 3 THEN 'Medium Frequency'    -- 3-9 transactions per month
                ELSE 'Low Frequency'                                        -- 0-2 transactions per month
            END AS frequency_category
        FROM 
            monthly_transactions
        GROUP BY 
            owner_id
    )

-- Aggregate results by frequency category to get overall statistics
SELECT
    frequency_category,
    COUNT(*) AS customer_count,                                  -- Number of customers in each category
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month  -- Average transactions (rounded to 1 decimal)
FROM 
    customer_avg_transactions
GROUP BY 
    frequency_category
ORDER BY 
    -- Sort results with High Frequency first, then Medium, then Low
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
