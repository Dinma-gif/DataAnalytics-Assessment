-- Step 1: Find the latest inflow transaction per plan (Savings or Investment) for
-- active users
with
    last_inflow_per_plan as (
        select
            p.id as plan_id,
            p.owner_id,
            case
                when p.is_a_fund = true
                then 'Investment'
                when p.is_regular_savings = true
                then 'Savings'
                else 'Other'
            end as type,
            max(sa.transaction_date) as last_transaction_date
        from plans_plan p
        join users_customuser u on p.owner_id = u.id
        join savings_savingsaccount sa on p.id = sa.plan_id
        where
            u.is_active = true
            and (p.is_regular_savings = true or p.is_a_fund = true)
            and sa.confirmed_amount > 0  -- Only positive inflow transactions
        group by p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
    )

-- Step 2: Select plans with no inflow transactions for more than 365 days
select
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    extract(day from (current_date - last_transaction_date))::integer as inactivity_days -- extract activity days by subtracting last_tran_date from current date
from last_inflow_per_plan
where current_date - last_transaction_date > 365
order by inactivity_days desc
;
