{% test unique_key(model, columns) %}
select
    {% for column_name in columns %}
        "{{ column_name }}"::text ||
    {% endfor %}
    ''
from
    {{ model }}
group by
    1
having
    count(*) > 1
{% endtest %}
