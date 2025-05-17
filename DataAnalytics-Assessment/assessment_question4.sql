with
    customer_tenure as (
        select
            id as customer_id,
            first_name,
            last_name,
            datediff(month, date_joined, current_date) as tenure_months
        from users_customuser
    ),

    customer_transactions as (
        select
            ct.customer_id,
            ct.first_name,
            ct.last_name,
            ct.tenure_months,
            count(sa.id) as total_transactions,
            coalesce(sum(sa.confirmed_amount), 0) as total_transaction_amount
        from customer_tenure ct
        left join savings_savingsaccount sa on ct.customer_id = sa.owner_id
        group by ct.customer_id, ct.first_name, ct.last_name, ct.tenure_months
        having ct.tenure_months >= 1
    )

select
    customer_id,
    first_name || ' ' || last_name as name,
    tenure_months,
    total_transactions,
    round(
        ((total_transactions * 1.0) / tenure_months)
        * 12
        * ((total_transaction_amount * 0.001) / total_transactions),
        2
    ) as estimated_clv
from customer_transactions
where total_transactions > 0 and total_transaction_amount > 0
order by estimated_clv desc
;
