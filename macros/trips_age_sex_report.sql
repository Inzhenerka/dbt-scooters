{% macro trips_age_sex_report(trips_table, granularity) %}
{%- set time_column -%}
    {%- if granularity == 'daily' -%}
        "date"
    {%- elif granularity == 'weekly' -%}
        date_trunc('week', "date")::date as "week"
    {%- elif granularity == 'monthly' -%}
        date_trunc('month', "date")::date as "month"
    {%- else -%}
        {{ exceptions.raise_compiler_error("Invalid granularity: " ~ granularity) }}
    {%- endif -%}
{%- endset -%}
select
    {{ time_column }},
    age,
    coalesce(sex, 'UNKNOWN') as sex,
    count(*) as trips,
    sum(price_rub) as revenue_rub
from
    {{ trips_table }}
group by
    1,
    2,
    3
{% endmacro %}
