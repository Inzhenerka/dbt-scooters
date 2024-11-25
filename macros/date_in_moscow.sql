{% macro date_in_moscow(ts_col) %}
    date({{ ts_col }} at time zone 'Europe/Moscow')
{% endmacro %}
