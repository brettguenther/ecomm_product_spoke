explore: order_items_partitioned_clustered {}
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

  measure: total_sales_change_month_over_month {
    type: period_over_period
    kind: relative_change
    period: month
    based_on: total_sale_price
    based_on_time: created_date
    description: "total sales previous month relative change"
    value_format_name: percent_1
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }
# 1. Base Measure for Contribution Percentage
  measure: sales_contribution_percent {
    description: "The percentage contribution of the current row's sales to the total sales in the result set."
    type: number
    sql: 1.0 * ${total_sale_price} / NULLIF(SUM(${total_sale_price}) OVER(), 0) ;;
    value_format_name: percent_2
  }

  # 2. Compliance Logic Measure
  measure: compliance_status {
    description: "Returns 'Not compliance' if Product Group > 70% or Principal Name > 80% contribution."
    type: string
    sql:
      CASE
        WHEN ${sales_contribution_percent} > 0.70
             AND ${product_id} IS NOT NULL THEN 'Not compliance'
        WHEN ${sales_contribution_percent} > 0.80
             AND ${order_id} IS NOT NULL THEN 'Not compliance'
        ELSE 'Compliant'
      END ;;
  }

# 2. Dynamic Compliance Measure
  # Applies logic: >70% for Product Group, >80% for Principal Name
  measure: compliance_status_dynamic {
    description: "Flags 'Not compliance' based on grain: >70% for Product Group, >80% for Principal Name."
    type: string
    sql:
      CASE
        WHEN
          {% if product_id._is_selected %}
            ${sales_contribution_percent} > 0.0002
          {% elsif order_id._is_selected %}
            ${sales_contribution_percent} > 0.0001
          {% else %}
            1=0 -- Default to false if neither specific grain is used
          {% endif %}
        THEN 'Not compliance'
        ELSE 'Compliant'
      END ;;
  }
}
