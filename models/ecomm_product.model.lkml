connection: "default_bigquery_connection"

include: "/views/**/*.view.lkml"

include: "//ecomm_hub/datagroups.base.lkml"

include: "//ecomm_hub/explores/*.base.explore"

persist_with: ecommerce_etl

#Spoke example explore #1: new explore (events), with a refined view

explore: events {
  group_label: "Product Analytics"
  label: "Event Analytics"
  join: users {
    sql_on: ${events.user_id} = ${users.id} ;;
    type: left_outer
    relationship: many_to_one
  }
}

#Spoke example explore #2: refined + extended explore

explore: order_items_inventory {
  group_label: "Product Analytics"
  label: "Orders & Inventory"
  view_name: order_items
  # from:
  extends: [order_items, inventory_items]
}
