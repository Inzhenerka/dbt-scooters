select
    age,
    {{ dbt_utils.pivot("sex", ["M", "F"]) }}
from
    {{ ref("trips_users") }}
group by
    1
order by
    1
