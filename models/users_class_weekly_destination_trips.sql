with
daily_stat_cte as (
    /* For each user, we find the trip statistics to each destination
    for each day:
      morning_trips - the number of morning trips */
    select
        user_id,
        "date",
        st_snaptogrid(
            st_makepoint(finish_lon, finish_lat), 0.001
        ) as destination,
        count(
            case when extract(
                hour from started_at at time zone 'Europe/Moscow'
            ) between 6 and 10 then 1 end
        ) as morning_trips
    from
        {{ ref('trips_prep') }}
    group by
        1,
        2,
        3
),

weekly_stat_cte as (
    /* For each user, we find the trip statistics to each destination
    for each week:
      morning_trip_days - the number of days with morning trips */
    select
        user_id,
        destination,
        date_trunc('week', "date") as "week",
        count(
            distinct
            case when morning_trips > 0 then "date" end
        ) as morning_trip_days
    from
        daily_stat_cte
    group by
        1,
        2,
        3
),

prep_weekly_destination_trips_cte as (
    /* Preparing data for profiling users based on trips to a specific destination during the week.
    For each user, we find the list of unique destinations
    and the trip statistics to those destinations:
      avg_morning_trip_days - the average number of days with morning trips per week */
    select
        user_id,
        destination,
        avg(morning_trip_days) as avg_morning_trip_days
    from
        weekly_stat_cte
    group by
        1,
        2
)

select
    user_id,
    max(avg_morning_trip_days) >= 3 as to_work
from
    prep_weekly_destination_trips_cte
group by
    1
