-- Identify customers with at least one funded savings and one funded investment plan,
-- along with counts and total deposits in naira
with
    users as (
        select
            id as user_id,
            initcap(coalesce(first_name, '')) as first_name,
            initcap(coalesce(last_name, '')) as last_name
        from users_customuser
    ),

    -- Sum deposits for savings plans only (funded plans)
    savings_users as (
        select
            sa.owner_id,
            count(distinct sa.plan_id) as savings_count,
            sum(coalesce(sa.confirmed_amount, 0)) as savings_deposit_kobo
        from savings_savingsaccount sa
        join plans_plan p on sa.plan_id = p.id
        where p.is_regular_savings = 1 and sa.confirmed_amount > 0
        group by sa.owner_id
    ),

    -- Sum deposits for investment plans only (funded plans)
    investment_users as (
        select
            sa.owner_id,
            count(distinct sa.plan_id) as investment_count,
            sum(coalesce(sa.confirmed_amount, 0)) as investment_deposit_kobo
        from savings_savingsaccount sa
        join plans_plan p on sa.plan_id = p.id
        where p.is_a_fund = 1 and sa.confirmed_amount > 0
        group by sa.owner_id
    ),

    final as (
        select
            u.user_id as owner_id,
            -- Construct full name or default to 'Unknown' if blank
            coalesce(
                nullif(
                    trim(
                        coalesce(u.first_name, '') || ' ' || coalesce(u.last_name, '')
                    ),
                    ''
                ),
                'Unknown'
            ) as name,
            s.savings_count,
            i.investment_count,
            -- Convert kobo to naira and round to 2 decimal places
            round(
                ((s.savings_deposit_kobo + i.investment_deposit_kobo)::numeric) / 100, 2
            ) as total_deposits
        from users u
        inner join savings_users s on s.owner_id = u.user_id
        inner join investment_users i on i.owner_id = u.user_id
    )

select owner_id, name, savings_count, investment_count, total_deposits
from final
order by total_deposits desc
;
