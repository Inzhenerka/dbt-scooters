{%- macro get_meta_value(model, meta_key, def_value="null") -%}
    {# Get meta value from model configuration #}
    {%- if execute -%}
        {# Graph object is available only during Run phase #}
        {% set model_node = (
            graph.nodes.values() |
            selectattr("resource_type", "equalto", "model") |
            selectattr("alias", "equalto", model.name) |
            first
        ) %}
            {{ return(model_node.get("meta", {}).get(meta_key, def_value)) }}
    {%- else -%}
        {# During Parse phase, return default value #}
        {{ return(def_value) }}
    {%- endif -%}
{%- endmacro -%}
