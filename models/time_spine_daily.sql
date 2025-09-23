with days as (
    {{ dbt.date_spine(
        'day',
        "date '2023-06-01'",
        "date '2023-08-31'"
    ) }}
),

final as (
    select cast(date_day as date) as date_day
    from days
)

select *
from final
