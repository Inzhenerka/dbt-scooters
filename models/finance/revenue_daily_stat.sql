select
    count(*) as "days",
    sum(revenue_rub) as revenue_rub,
    avg(revenue_rub) as avg_revenue_rub,
    max(updated_at) as updated_at
from
    {{ ref("revenue_daily") }}
