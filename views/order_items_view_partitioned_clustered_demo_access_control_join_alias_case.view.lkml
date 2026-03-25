view: order_items_view_partitioned_clustered_demo_access_control_join_alias_case {
  sql_table_name: `stellar-cumulus-449523-b8.test_dataset.order_items_view_partitioned_clustered_demo_access_control_join_alias_case` ;;

  dimension_group: view_created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.view_created_at ;;
  }
  dimension_group: view_delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.view_delivered_at ;;
  }
  dimension: view_inventory_item_id {
    type: number
    sql: ${TABLE}.view_inventory_item_id ;;
  }
  dimension: view_order_id {
    type: number
    sql: ${TABLE}.view_order_id ;;
  }
  dimension: view_order_item_id {
    type: number
    sql: ${TABLE}.view_order_item_id ;;
  }
  dimension: view_product_id {
    type: number
    sql: ${TABLE}.view_product_id ;;
  }
  dimension_group: view_returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.view_returned_at ;;
  }
  dimension: view_sale_price {
    type: number
    sql: ${TABLE}.view_sale_price ;;
  }
  dimension: view_status {
    type: string
    sql: ${TABLE}.view_status ;;
  }
  dimension: view_user_id {
    type: number
    sql: ${TABLE}.view_user_id ;;
  }
  measure: count {
    type: count
  }
}
