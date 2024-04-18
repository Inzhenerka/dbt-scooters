select
    sum(price_rub) as revenue_rub,
    "date",
    now() at time zone 'utc' as updated_at
from
    {{ ref("trips_prep") }}
{% if is_incremental() %}
where
    "date" >= (select max("date") - interval '2' day from {{ this }})
{% endif %}
group by
    2,
    3
order by
    2
