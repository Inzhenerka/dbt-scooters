select
    id,
    sex,
    birth_date
from
    {{ source("scooters_raw", "users") }}
