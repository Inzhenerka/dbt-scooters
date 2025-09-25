with diff_cte as (
    select
        *,
        lead(event_ts) over (partition by scooter_id order by event_ts) - event_ts as next_gap,
        extract(
            epoch from (
                lead(event_ts) over (partition by scooter_id order by event_ts) - event_ts
            )
        ) as next_gap_seconds
    from
        {{ ref('battery_state_clean').render() }}
    where
        battery_percent is not null
        and {{ microbatch_condition(ref('battery_state_clean'), end_offset_days=1) }}
)
select
    *
from
    diff_cte
where
    {{ microbatch_condition(ref('battery_state_clean')) }}
