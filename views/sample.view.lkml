view: sample {
  sql_table_name: `New_yj.sample` ;;

  dimension: category {
    type: string
    sql: ${TABLE}.Category ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.City ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.Country ;;
  }
  dimension: customer_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.CustomerID ;;
  }
  dimension: customer_name {
    type: string
    sql: ${TABLE}.CustomerName ;;
  }
  dimension: discount {
    type: number
    sql: ${TABLE}.Discount ;;
  }
  dimension: market {
    type: string
    sql: ${TABLE}.Market ;;
  }
  dimension_group: order {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.OrderDate ;;
  }
  dimension: order_id {
    type: string
    sql: ${TABLE}.OrderID ;;
  }
  dimension: order_priority {
    type: string
    sql: ${TABLE}.OrderPriority ;;
  }
  dimension: postal_code {
    type: number
    sql: ${TABLE}.PostalCode ;;
  }
  dimension: product_id {
    type: string
    sql: ${TABLE}.ProductID ;;
  }
  dimension: product_name {
    type: string
    sql: ${TABLE}.ProductName ;;
  }
  dimension: profit {
    type: number
    sql: ${TABLE}.Profit ;;
  }
  dimension: quantity {
    type: number
    sql: ${TABLE}.Quantity ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }
  dimension: row_id {
    type: number
    sql: ${TABLE}.RowID ;;
  }
  dimension: sales {
    type: number
    sql: ${TABLE}.Sales ;;
  }
  dimension: segment {
    type: string
    sql: ${TABLE}.Segment ;;
  }
  dimension_group: ship {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ShipDate ;;
  }
  dimension: ship_mode {
    type: string
    sql: ${TABLE}.ShipMode ;;
  }
  dimension: shipping_cost {
    type: number
    sql: ${TABLE}.ShippingCost ;;
  }
  dimension: state {
    type: string
    sql: ${TABLE}.State ;;
  }
  dimension: subcategory {
    type: string
    sql: ${TABLE}.`Sub-Category` ;;
  }
  measure: count {
    type: count
    drill_fields: [product_name, customer_name]
  }
}
