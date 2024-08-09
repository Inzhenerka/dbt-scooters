{% macro create_postgis(name) %}
    {% set query %}
        create extension if not exists postgis schema public;
    {% endset %}
    {% do log("Creating postgis extension", info=True) %}
    {% do run_query(query) %}
{% endmacro %}
