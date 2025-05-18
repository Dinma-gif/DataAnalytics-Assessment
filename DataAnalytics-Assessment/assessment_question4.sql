
WITH 
    -- Step 1: Calculate customer tenure in months with improved NULL handling
    customer_tenure AS (
        SELECT
            id AS customer_id,
            -- Consistent NULL/empty string handling with explicit trimming
            COALESCE(NULLIF(TRIM(first_name), ''), 'Unknown') AS first_name,
            COALESCE(NULLIF(TRIM(last_name), ''), 'Unknown') AS last_name,
            -- Pre-calculate tenure in months once to avoid redundant calculations
            DATEDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
        FROM 
            users_customuser
        WHERE 
            -- Filter early to reduce dataset size
            date_joined IS NOT NULL
            AND DATEDIFF(MONTH, date_joined, CURRENT_DATE) >= 1
    ),
    
    -- Step 2: Aggregate transaction data per customer with optimized joins
    customer_transactions AS (
        SELECT
            ct.customer_id,
            ct.first_name,
            ct.last_name,
            ct.tenure_months,
            COUNT(sa.id) AS total_transactions,
            -- Use COALESCE with explicit zero to handle NULL sums
            COALESCE(SUM(sa.confirmed_amount), 0) AS total_transaction_amount
        FROM 
            customer_tenure ct
        LEFT JOIN 
            savings_savingsaccount sa ON ct.customer_id = sa.owner_id
                                  -- Move filter conditions to JOIN clause for better optimization
                                  AND sa.confirmed_amount > 0
        GROUP BY 
            ct.customer_id, ct.first_name, ct.last_name, ct.tenure_months
    )

-- Step 3: Calculate and output the estimated CLV values
SELECT
    customer_id,
    -- Concatenate name elements with proper spacing
    TRIM(first_name || ' ' || last_name) AS customer_name,
    tenure_months,
    total_transactions,
    -- Improved CASE expression with proper division handling
    CASE
        WHEN total_transactions > 0 AND tenure_months > 0 THEN
            ROUND((total_transaction_amount * 0.012) / tenure_months, 2)
        ELSE 0
    END AS estimated_clv
FROM 
    customer_transactions
WHERE 
    -- Combined filter conditions for clarity
    total_transactions > 0 AND total_transaction_amount > 0
ORDER BY 
    estimated_clv DESC;
