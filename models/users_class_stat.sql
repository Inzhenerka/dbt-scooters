select
    count(fan or null) as fan_count,
    count(regular or null) as regular_count,
    count(rare or null) as rare_count,
    count(to_work or null) as to_work_count,
    count(no_class or null) as no_class_count,
    count(*) as total_count
from
    {{ ref('users_class') }}
