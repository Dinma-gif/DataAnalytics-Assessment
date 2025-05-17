-- Calculate the number of transactions per customer per month
with
    monthly_transactions as (
        select
            owner_id,
            date_trunc('month', transaction_date) as month_year,
            count(*) as transaction_count
        from savings_savingsaccount
        group by owner_id, month_year
    ),

    -- Calculate average monthly transactions per customer and categorize
    -- frequency
    customer_avg_transactions as (
        select
            owner_id,
            avg(transaction_count) as avg_monthly_transactions,
            case
                when avg(transaction_count) >= 10
                then 'High Frequency'
                when avg(transaction_count) between 3 and 9
                then 'Medium Frequency'
                else 'Low Frequency'
            end as frequency_category
        from monthly_transactions
        group by owner_id
    )

-- Step 3: Aggregate results by frequency category
select
    frequency_category,
    count(*) as customer_count,
    round(avg(avg_monthly_transactions), 1) as avg_transactions_per_month
from customer_avg_transactions
group by frequency_category
order by
    case
        frequency_category
        when 'High Frequency'
        then 1
        when 'Medium Frequency'
        then 2
        else 3
    end
;
