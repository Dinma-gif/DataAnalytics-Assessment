-- Purpose: Identify inactive savings or investment plans with no inflows in the last 365 days
WITH active_plans AS (
    SELECT
        id AS plan_id,
        owner_id,
        CASE
            WHEN is_a_fund THEN 'Investment'
            WHEN is_regular_savings THEN 'Savings'
            ELSE 'Other'
        END AS plan_type
    FROM plans_plan
    WHERE is_regular_savings = TRUE OR is_a_fund = TRUE
),
last_inflows AS (
    SELECT
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
)
SELECT
    ap.plan_id,
    ap.owner_id,
    ap.plan_type,
    li.last_transaction_date,
     -- 9999 is a place holder for customers who havent transacted at all
    COALESCE(DATEDIFF(day, li.last_transaction_date, CURRENT_DATE), 9999) AS inactivity_days
FROM active_plans ap
LEFT JOIN last_inflows li ON ap.plan_id = li.plan_id
WHERE
    li.last_transaction_date IS NULL OR
    DATEDIFF(day, li.last_transaction_date, CURRENT_DATE) > 365
ORDER BY
    li.last_transaction_date IS NULL DESC,
    inactivity_days DESC;
