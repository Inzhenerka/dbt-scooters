with
unnest_cte as (
    -- Unnest trip to two rows: start and finish events
    select
        unnest(array[started_at, finished_at]) as "timestamp",
        unnest(array[1, -1]) as increment
    from
        {{ source("scooters_raw", "trips") }}
),

sum_cte as (
    -- Make timestamp unique, group increments, add initial concurrency from history
    select
        "timestamp",
        sum(increment) as increment,
        true as preserve_row
    from
        unnest_cte
    where
        {% if is_incremental() %}
            "timestamp" > (select max("timestamp") from {{ this }})
        {% else %}
        "timestamp" < (date '2023-06-01' + interval '7' hour) at time zone 'Europe/Moscow'
    {% endif %}
    group by
        1
    {% if is_incremental() %}
        union all
        select
            "timestamp",
            concurrency as increment,
            false as preserve_row
        from
            {{ this }}
        where
            "timestamp" = (select max("timestamp") from {{ this }})
    {% endif %}
),

cumsum_cte as (
    -- Integrate increment to get concurrency
    select
        "timestamp",
        preserve_row,
        sum(increment) over (
            order by "timestamp"
        ) as concurrency
    from
        sum_cte
)

select
    "timestamp",
    concurrency,
    {{ updated_at() }}
from
    cumsum_cte
where
    preserve_row
order by
    1
