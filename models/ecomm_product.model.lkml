connection: "default_bigquery_connection"

include: "/views/**/*.product.view.lkml"

include: "//ecomm_hub/datagroups.base.lkml"

include: "//ecomm_hub/explores/*.base.explore"

# include: "//ecomm_hub/views/*.base.view"

persist_with: ecommerce_etl

#Spoke example explore #2: extended explore

explore: order_items_inventory {
  group_label: "Product Analytics"
  label: "Orders & Inventory"
  view_name: order_items
  extends: [order_items, inventory_items]
}


#Spoke example explore #1: new explore (events), with a refined view

explore: events {
  group_label: "Product Analytics"
  label: "Event Analytics"
  join: users {
    sql_on: ${events.user_id} = ${users.id} ;;
    type: left_outer
    relationship: many_to_many
  }
}

explore: order_items_product {
  label: "Ecomm Product - Order Items SQL Preamble"
  view_name: order_items
  always_filter: {
    filters: [base_calendar.fiscal_date: "this year"]
  }
  # sql_preamble: DECLARE min_calendar_time DEFAULT (SELECT min(custom_calendar.calendar_date) FROM `stellar-cumulus-449523-b8.looker_scratch_us.LR_ETOUD1759871011742_custom_calendar` as custom_calendar where {% condition custom_calendar.fiscal_date %} custom_calendar.fiscal_date {% endcondition %} LIMIT 1);
  # DECLARE max_calendar_time DEFAULT (SELECT max(custom_calendar.calendar_date) FROM `stellar-cumulus-449523-b8.looker_scratch_us.LR_ETOUD1759871011742_custom_calendar` as custom_calendar where {% condition custom_calendar.fiscal_date %} custom_calendar.fiscal_date {% endcondition %} LIMIT 1); ;;

  sql_preamble: DECLARE min_calendar_time DEFAULT (SELECT min(custom_calendar.calendar_date) FROM ${base_calendar.SQL_TABLE_NAME} as custom_calendar where {% condition base_calendar.fiscal_date %} custom_calendar.fiscal_date {% endcondition %} LIMIT 1);
    DECLARE max_calendar_time DEFAULT (SELECT max(custom_calendar.calendar_date) FROM ${base_calendar.SQL_TABLE_NAME} as custom_calendar where {% condition base_calendar.fiscal_date %} custom_calendar.fiscal_date {% endcondition %} LIMIT 1); ;;


  sql_always_where: ${order_items.created_date} >  min_calendar_time and ${order_items.created_date} < max_calendar_time ;;

  join: base_calendar {
    sql_on: ${order_items.created_date} = ${base_calendar.calendar_date};;
    relationship: many_to_one
  }
  join: users {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }
  join: inventory_items {
    view_label: "Inventory Items"
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
}
