view: user_events {
  derived_table: {
    explore_source: events {
      column: user_id {}
      column: sessions_count {}
      column: count {}
      # dev_filters: []
    }
  }
  dimension: user_id {
    description: ""
  }
  dimension: sessions_count {
    description: ""
    type: number
  }
  dimension: count {
    description: ""
    type: number
  }
}
