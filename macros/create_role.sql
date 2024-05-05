{% macro create_role(name) %}
    {% set query %}
        create role {{ name }} nologin;
    {% endset %}
    {% do log("Creating role: " ~ name, info=True) %}
    {% do run_query(query) %}
{% endmacro %}
