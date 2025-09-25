with bounds_cte as (
    select
        date_trunc('day', now() at time zone 'utc')::timestamp as end_ts,
        timestamp '2025-07-01' as start_ts
),

timestamps_cte as (
    select gs.event_ts
    from bounds_cte
    cross join lateral generate_series(bounds_cte.start_ts, bounds_cte.end_ts, interval '1 hour') as gs (event_ts)
),

scooters_cte as (
    select format('scooter_%s', lpad(i::text, 3, '0')) as scooter_id
    from generate_series(1, 10) as g (i)
)

select
    ts.event_ts,
    s.scooter_id,
    case when random() < 0.1 then null else floor(random() * 101)::int end as battery_percent
from timestamps_cte as ts
cross join scooters_cte as s
order by ts.event_ts, s.scooter_id
