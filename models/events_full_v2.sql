with events_clean_cte as (
    select * from {{ ref('events_clean') }}
),
events_full_cte as (
    select * from {{ ref('event_types') }}
)
select
    *,
    date("timestamp") as "date"
from
    events_clean_cte
    left join events_full_cte
        using (type_id)
