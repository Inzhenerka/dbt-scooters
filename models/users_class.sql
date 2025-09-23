select
    u.id as user_id,
    w.fan,
    w.regular,
    m.rare,
    wd.to_work,
    not(w.fan or w.regular or m.rare or wd.to_work) as no_class
from
    {{ ref('users_prep') }} as u
full outer join {{ ref('users_class_weekly_trips') }} as w
    on u.id = w.user_id
full outer join {{ ref('users_class_weekly_destination_trips') }} as wd
    using (user_id)
full outer join {{ ref('users_class_monthly_trips') }} as m
    using (user_id)
