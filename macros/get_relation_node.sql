{% macro get_relation_node(relation) -%}
  {% set node = _get_ref_node(relation) %}
  {% if node is not none %}
    {% do return(node) %}
  {% endif %}

  {% set node = _get_source_node(relation) %}
  {% if node is not none %}
    {% do return(node) %}
  {% endif %}

  {% do exceptions.raise_compiler_error(
    "get_relation_node: no node found for relation " ~ relation ~ ". Checked models/seeds (ref) and sources."
  ) %}
{%- endmacro %}


{% macro _get_ref_node(relation) -%}
  {% set db  = (relation.database  | default(target.database) | lower) %}
  {% set sch = (relation.schema    | lower) %}
  {% set id  = (relation.identifier| lower) %}

  {% for node in graph.nodes.values() %}
    {% if node.resource_type in ['model', 'seed'] %}
      {% set ndb = (node.database | default(target.database) | lower) %}
      {% set nsch = (node.schema   | lower) %}
      {% set nid  = (node.alias    | lower) %}
      {% if db == ndb and sch == nsch and id == nid %}
        {% do return(node) %}
      {% endif %}
    {% endif %}
  {% endfor %}

  {% do return(none) %}
{%- endmacro %}


{% macro _get_source_node(relation) -%}
  {% set db  = (relation.database  | default(target.database)) %}
  {% set sch = relation.schema %}
  {% set id  = relation.identifier %}

  {% for node in graph.sources.values() %}
    {% set ndb = (node.database | default(target.database)) %}
    {% set nsch = node.schema %}
    {% set nid  = (node.identifier or node.name) %}
    {% if db == ndb and sch == nsch and id == nid %}
      {% do return(node) %}
    {% endif %}
  {% endfor %}

  {% do return(none) %}
{%- endmacro %}
