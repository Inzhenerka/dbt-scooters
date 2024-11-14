select
    ag."group" as age_group,
    count(*) as trips,
    sum(price_rub) as revenue_rub
from
    {{ ref("trips_users") }} as tu
    cross join {{ ref("age_groups") }} as ag
where
    tu.age >= ag.age_start
    and tu.age <= ag.age_end
group by
    1
