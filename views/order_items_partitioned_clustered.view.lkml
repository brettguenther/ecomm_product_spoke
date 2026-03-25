view: order_items_partitioned_clustered {
  sql_table_name: `stellar-cumulus-449523-b8.test_dataset.order_items_partitioned_clustered` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    description: "Unique identifier for the line item"
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    description: "Timestamp when the order item was created"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    description: "Timestamp when the order item was delivered"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    description: "Identifier for the inventory item"
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    description: "Identifier for the order"
    sql: ${TABLE}.order_id ;;
  }
  dimension: product_id {
    type: number
    description: "Identifier for the product"
    sql: ${TABLE}.product_id ;;
  }
  dimension_group: returned {
    type: time
    description: "Timestamp when the order item was returned"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    description: "Sale price of the item"
    sql: ${TABLE}.sale_price ;;
  }
  dimension_group: shipped {
    type: time
    description: "Timestamp when the order item was shipped"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    type: string
    description: "Current status of the order item (e.g., Complete, Cancelled, Processing)"
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    type: number
    description: "Identifier for the user who placed the order"
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
