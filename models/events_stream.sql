{{ dbt_product_analytics.event_stream(
    from=ref("events_full"),
    event_type_col="type",
    user_id_col="user_id",
    date_col='"date"'
) }}
