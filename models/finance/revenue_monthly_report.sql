select
    *
from
    {{ ref("revenue_monthly") }}
where
    "month" < date_trunc('month', current_date)
    {%- if is_incremental() %}
        and "month" > (select max("month") from {{ this }})
    {%- else -%}
        and "month" = (select min("month") from {{ ref("revenue_monthly") }})
    {% endif -%}
    and not(users < 1000 or revenue_median < 500)
