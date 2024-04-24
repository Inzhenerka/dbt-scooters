with trips_cte as (
    select
        company,
        count(*) as trips
    from
        {{ ref("trips_prep") }} as t
        join {{ ref("models") }} as m
            on t.scooter_hw_id = m.hardware_id
    group by
        1
)
select
    company,
    t.trips,
    c.scooters,
    t.trips / cast(c.scooters as float) as trips_per_scooter
from
    trips_cte as t
    join {{ ref("companies") }} as c
        using (company)