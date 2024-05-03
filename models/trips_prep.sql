select
    id,
    user_id,
    scooter_hw_id,
    started_at,
    finished_at,
    start_lat,
    start_lon,
    finish_lat,
    finish_lon,
    distance as distance_m,
    cast(price as decimal(20, 2)) / 100 as price_rub,
    extract(epoch from (finished_at - started_at)) as duration_s,
    finished_at <> started_at and price = 0 as is_free,
    {{ date_in_moscow('started_at') }} as "date"
from
    {{ source("scooters_raw", "trips") }}
