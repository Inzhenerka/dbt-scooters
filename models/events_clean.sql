select distinct
    user_id,
    "timestamp",
    type_id,
    {{ updated_at() }}
from
    {{ source("scooters_raw", "events") }}
where
{% if is_incremental() %}
    "timestamp" > (select max("timestamp") from {{ this }})
{% else %}
    "timestamp" < timestamp '2023-08-01'
{% endif %}
