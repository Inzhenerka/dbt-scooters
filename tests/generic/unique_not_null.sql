{% test unique_not_null(model, column_name) %}
select
    "{{ column_name }}"
from
    {{ model }}
group by
    1
having
    count(*) > 1 or "{{ column_name }}" is null
{% endtest %}
