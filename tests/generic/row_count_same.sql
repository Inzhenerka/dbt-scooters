{%- test row_count_same(model, compare_model) -%}
    {{ dbt_expectations.test_expect_table_row_count_to_equal_other_table(
        model,
        compare_model
    ) }}
{% endtest %}
