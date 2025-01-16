select
    e.user_id,
    e."timestamp",
    type_id,
    et."type",
    e.updated_at,
    e."date"
from
    {{ ref('events_clean') }} as e
left join {{ ref('event_types') }} as et
    using (type_id)
