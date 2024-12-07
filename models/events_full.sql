select
    *,
    date("timestamp") as "date"
from
    {{ ref('events_clean') }}
    left join {{ ref('event_types') }}
        using (type_id)
