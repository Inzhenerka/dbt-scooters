with bounds_cte as (
    select
        date('2025-07-01')::timestamp as start_ts,
        date_trunc('day', (now() at time zone 'utc'))::timestamp as end_ts
),
timestamps_cte as (
    select
        gs as event_ts
    from
        bounds_cte as b,
        generate_series(b.start_ts, b.end_ts, interval '1 hour') as gs
),
scooters_cte as (
    select
        format('scooter_%s', lpad(i::text, 3, '0')) as scooter_id
    from
        generate_series(1, 10) g(i)
)
select
    ts.event_ts,
    s.scooter_id,
    case
        when random() < 0.1 then null
        else floor(random() * 101)::int
    end as battery_percent
from
    timestamps_cte as ts
    cross join scooters_cte as s
order by
    ts.event_ts,
    s.scooter_id
