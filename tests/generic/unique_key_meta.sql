{% test unique_key_meta(model) %}
    {# Test combination of columns declared as 'unique_key' meta field for uniqueness. #}
    {# Optionally test supports 'testing' meta dictionary of models for parameters. #}
    {%- set unique_key = get_meta_value(model, 'unique_key', none) -%}
    {%- if execute -%}
        {%- if unique_key is none -%}
            {{ exceptions.raise_compiler_error(
                "unique_key meta field is required for unique_key_meta test"
            ) }}
        {%- endif -%}
        {%- set unique_key_csv = unique_key | join(', ') -%}
    {%- endif -%}
    {# Extract 'testing' meta parameters. #}
    {%- set testing = get_meta_value(model, 'testing', {}) -%}
    {%- set days_max = testing.get('days_max', none) -%}
    {%- set date_column = testing.get('date_column', 'date') -%}
    with validation_errors as (
        select
            {{ unique_key_csv }}
        from {{ model }}
        {% if days_max -%}
            {%- set start_date_query -%}
                select max({{ date_column }}) - interval '{{ days_max }} day' from {{ model }}
            {%- endset -%}
            {%- set start_date = select_first_value(start_date_query) -%}
            where {{ date_column }} >= date '{{ start_date }}'
        {%- endif %}
        group by {{ unique_key_csv }}
        having count(*) > 1
    )
    select *
    from validation_errors
{% endtest %}
