{% set date = var("date", none) %}
select distinct
    user_id,
    "timestamp",
    type_id,
    {{ updated_at() }}
from
    {{ source("scooters_raw", "events") }}
where
    {% if is_incremental() %}
        {% if date %}
        date("timestamp") = date '{{ date }}'
    {% else %}
            "timestamp" > (select max("timestamp") from {{ this }})
        {% endif %}
    {% else %}
    "timestamp" < timestamp '2023-08-01'
{% endif %}
