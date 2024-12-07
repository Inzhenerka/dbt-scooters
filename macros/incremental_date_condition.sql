{%- macro incremental_date_condition(
    model,
    date=none,
    start_date=none,
    days_max=none,
    days_back_from_today=none
) -%}
    {%- if date is not none -%}
        "date" = date '{{ date }}'
    {%- else -%}
        {%- set incrementality = get_meta_value(model, 'incrementality', {}) -%}
        {{ _incremental_date_condition_range(
            model=model,
            start_date=start_date,
            initial_start_date=incrementality.get('start_date', none),
            days_max=days_max or incrementality.get('days_max', 30),
            days_back_from_today=days_back_from_today or incrementality.get('days_back_from_today', 1)
        ) }}
    {%- endif -%}
{%- endmacro -%}


{%- macro _incremental_date_condition_range(
    model,
    start_date,
    initial_start_date,
    days_max,
    days_back_from_today
) -%}
    {%- if start_date is none and execute -%}
        {%- if is_incremental() %}
            {%- set start_date_query -%}
                select max("date") + interval '1 day' from {{ model }}
            {%- endset -%}
            {%- set start_date = select_first_value(start_date_query) -%}
        {%- else -%}
            {%- if initial_start_date is none -%}
                {{ exceptions.raise_compiler_error(
                    "start_date or initial_start_date are required for initial non-incremental run"
                ) }}
            {%- endif -%}
            {%- set start_date = initial_start_date -%}
        {%- endif -%}
    {%- endif -%}
    "date" >= date '{{ start_date }}'
    and "date" < date '{{ start_date }}' + interval '{{ days_max }} day'
    and "date" <= current_date - interval '{{ days_back_from_today }} day'
{%- endmacro -%}
