{% macro microbatch_condition(relation=None, event_time=None, alias=None, start_offset_days=0, end_offset_days=0) -%}
  {%- if execute and model.batch is defined -%}
    {%- if relation is none -%}
      {%- set relation = model -%}
    {%- endif -%}

    {%- if not event_time -%}
      {%- set node = get_relation_node(relation) -%}
      {%- if node is not none and node.get('config') and node.config.get('event_time') -%}
        {%- set event_time = node.config.get('event_time') | trim -%}
      {%- endif -%}
    {%- endif -%}
    {%- if not event_time -%}
      {% do log(
        "microbatch_condition error: 'event_time' is not defined. "
        ~ "Pass it as macro parameter or specify in config of " ~ relation, info=true
      ) %}
      {% do exceptions.raise_compiler_error('microbatch_condition error') %}
    {%- endif -%}

    {%- set et_quoted = adapter.quote(event_time) -%}
    {%- if alias %}{{ alias }}.{% endif %}{{ et_quoted }} >= {{ dbt.dateadd('day', start_offset_days, "timestamp '" ~ model.batch.event_time_start ~ "'") }}
    and {%- if alias %} {{ alias }}.{% endif %}{{ et_quoted }} < {{ dbt.dateadd('day', end_offset_days, "timestamp '" ~ model.batch.event_time_end ~ "'") }}

  {%- else -%}
    1 = 1  /* Microbatch condition stub */
  {%- endif -%}
{%- endmacro %}
