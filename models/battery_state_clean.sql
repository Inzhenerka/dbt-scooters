select *
from
    {{ ref('battery_state') }}
where
    battery_percent is not null
