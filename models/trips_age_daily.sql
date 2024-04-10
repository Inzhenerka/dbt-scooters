with
date_age_cte as (
    select
        t.*,
        extract(year from t.started_at) - extract(year from u.birth_date) as age
    from
        {{ ref("trips_prep") }} as t
    inner join
        {{ source("scooters_raw", "users") }} as u
        on t.user_id = u.id
)

select
    "date",
    age,
    count(*) as trips,
    sum(price_rub) as revenue_rub
from
    date_age_cte
group by
    1,
    2
