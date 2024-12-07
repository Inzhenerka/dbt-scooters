{%- macro select_first_value(query) -%}
    {%- if execute -%}
        {{ return(run_query(query).columns[0].values()[0]) }}
    {%- endif -%}
{%- endmacro -%}
