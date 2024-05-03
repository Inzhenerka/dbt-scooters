with
unnest_cte as (
    select
        unnest(array[started_at, finished_at]) as "timestamp",
        unnest(array[1, -1]) as increment
    from
        {{ source("scooters_raw", "trips") }}
),
sum_cte as (
    select
        "timestamp",
        sum(increment) as increment,
        true as output_data
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
        false as output_data
    from
        {{ this }}
    where
        "timestamp" = (select max("timestamp") from {{ this }})
    {% endif %}
),
cumsum_cte as (
    select
        "timestamp",
        sum(increment) over (order by "timestamp") as concurrency,
        output_data
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
    output_data
order by
    1
