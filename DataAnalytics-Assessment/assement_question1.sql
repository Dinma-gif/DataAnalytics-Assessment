with
    users as (
        select
            id as user_id,
            initcap(coalesce(first_name, '')) as first_name,
            initcap(coalesce(last_name, '')) as last_name
        from {{ref ('stg_public__users') }}
    ),

    savings_users as (
        select
            owner_id,
            count(distinct plan_id) as savings_count,
            sum(coalesce(amount, 0)::numeric) as savings_deposit
        from {{ref ('stg_public__savings_savingaccount') }}
        where amount is not null and amount > 0
        group by owner_id

    ),

    investment_users as (
        select
            owner_id,
            count(distinct id) as investment_count,
            sum(coalesce(amount, 0)::numeric) as investment_deposits
        from {{ref ('stg_public__plans_plan')}}
        where amount is not null and amount > 0
        group by owner_id
    ),

    final as (
        select
            u.user_id as owner_id,
            coalesce(
                nullif(
                    trim(coalesce(first_name, '') || ' ' || coalesce(last_name, '')), ''
                ),
                'Unknown'
            ) as name,
            s.savings_count,
            i.investment_count,
            round(s.savings_deposit + i.investment_deposits, 2) as total_deposits
        from users u
        inner join savings_users s on s.owner_id = u.user_id
        inner join investment_users i on i.owner_id = u.user_id
    )

select owner_id, name, savings_count, investment_count, total_deposits
from final
order by total_deposits desc
