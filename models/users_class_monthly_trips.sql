with monthly_stat_cte as (
    /* For each user, we find the monthly trip statistics:
      trips_per_month - the number of trips per month */
    select
        user_id,
        date_trunc('month', "date") as "month",
        count(*) as trips_per_month
    from
        {{ ref('trips_prep') }}
    group by
        1,
        2
)

/* User profiling based on the number of trips per month:
  rare - infrequent/occasional trips, no more than 2 trips per month */
select
    user_id,
    sum(trips_per_month) <= 2 as rare
from
    monthly_stat_cte
group by
    1
