WITH
    active_users AS (
        SELECT
            id AS user_id,
            COALESCE(
                NULLIF(
                    TRIM(
                        INITCAP(COALESCE(first_name, '')) || ' ' || INITCAP(COALESCE(last_name, ''))
                    ),
                    ''
                ),
                'Unknown'
            ) AS name
        FROM 
            users_customuser
    ),
    
    -- Filter for funded accounts first to reduce dataset records, then join and filter by plan type
    funded_accounts AS (
        SELECT
            owner_id,
            plan_id,
            confirmed_amount
        FROM 
            savings_savingsaccount
        WHERE 
            confirmed_amount > 0
    ),
    
    -- Sum deposits for savings plans only
    savings_users AS (
        SELECT
            fa.owner_id,
            COUNT(DISTINCT fa.plan_id) AS savings_count,
            SUM(fa.confirmed_amount) AS savings_deposit_kobo
        FROM 
            funded_accounts fa
        JOIN 
            plans_plan p ON fa.plan_id = p.id
        WHERE 
            p.is_regular_savings = 1
        GROUP BY 
            fa.owner_id
    ),
    
    -- Sum deposits for investment plans only
    investment_users AS (
        SELECT
            fa.owner_id,
            COUNT(DISTINCT fa.plan_id) AS investment_count,
            SUM(fa.confirmed_amount) AS investment_deposit_kobo
        FROM 
            funded_accounts fa
        JOIN 
            plans_plan p ON fa.plan_id = p.id
        WHERE 
            p.is_a_fund = 1
        GROUP BY 
            fa.owner_id
    )

SELECT
    u.user_id AS owner_id,
    u.name,
    s.savings_count,
    i.investment_count,
    ROUND(
        ((COALESCE(s.savings_deposit_kobo, 0) + COALESCE(i.investment_deposit_kobo, 0))::NUMERIC) / 100, 
        2
    ) AS total_deposits
FROM 
    active_users u
INNER JOIN 
    savings_users s ON s.owner_id = u.user_id
INNER JOIN 
    investment_users i ON i.owner_id = u.user_id
ORDER BY 
    total_deposits DESC;
