select distinct
    user_id,
    "timestamp",
    type_id,
    {{ updated_at() }},
    "date"
from
    {{ ref("events_prep") }}
where
    {{ incremental_date_condition(
        model=this,
        date=var('date', none),
        start_date=var('start_date', none),
        days_max=var('days_max', none)
    ) }}
