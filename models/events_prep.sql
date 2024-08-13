select
    user_id,
    "timestamp",
    type_id,
    date("timestamp") as "date"
from
    {{ source("scooters_raw", "events") }}
