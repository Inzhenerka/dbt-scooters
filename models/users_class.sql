select
    id as user_id,
    fan,
    regular,
    rare,
    to_work,
    not(fan or regular or rare or to_work) as no_class
from
    {{ ref('users_prep') }}
full outer join {{ ref('users_class_weekly_trips') }}
    on user_id = id
full outer join {{ ref('users_class_weekly_destination_trips') }}
    using (user_id)
full outer join {{ ref('users_class_monthly_trips') }}
    using (user_id)
