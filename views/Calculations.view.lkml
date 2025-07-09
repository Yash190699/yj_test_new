
view: calculation {

  required_access_grants: [view_calculations]
  derived_table: {
    sql: SELECT
          (sample.OrderDate ) AS sample_order_date,
          (sample.ShipDate ) AS sample_ship_date,
          sample.Sales  AS sample_sales,
          sample.Profit  AS sample_profit,
          sample.CustomerID  AS sample_customer_id,
          sample.OrderID  AS sample_order_id,
          sample.Category  AS sample_category,
          sample.`Sub-Category`  AS sample_subcategory,
          sample.Country AS country,
          sample.State AS State,
          sample.City AS city,
          sample.PostalCode As postalcode,
          sample.CustomerName As CustomerName,
          sample.Segment AS segment,
          sample.Quantity As quantity_sold,
          sample.ProductName As Product_Name,
          AVG(sample.Discount) As Discount,
          COUNT(*) AS sample_count,
          ROUND(sample.Profit/sample.Sales,2) As Profit_ratio,
          DATE_DIFF(sample.ShipDate, sample.OrderDate, Day) AS days_to_ship,
          ROUND(SUM(sample.Sales)/COUNT(DISTINCT sample.CustomerID),2) AS sales_per_customer,
          CASE WHEN SUM(sample.Sales) >= 10000 THEN 'High'
          WHEN SUM(sample.Sales) BETWEEN 5000 AND 9999 THEN 'Medium'
          ELSE 'Low' END AS customer_lifetime_value_segmentation,
          SUM(sample.Sales) AS total_sales,
          SUM(sample.Profit) AS total_profit,
          COUNT(sample.OrderID) As total_orders,
          COUNT(sample.CustomerID) AS total_customers,
          EXTRACT(YEAR FROM sample.OrderDate) AS order_year,
          EXTRACT(month FROM sample.OrderDate) AS order_month,
          EXTRACT(quarter FROM sample.OrderDate) AS order_quarter


          FROM `New_yj.sample`  AS sample
      GROUP BY
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16
      ORDER BY
          1 DESC
     ;;
  }
dimension: CustomerName {
  type: string
  sql: ${TABLE}.CustomerName ;;
}
measure: Discount {
  type: average
  sql: ${TABLE}.Discount ;;
}
dimension: Product_name {
  type: string
  sql: ${TABLE}.Product_Name ;;
  link: {
    url: "https://gcpl2510.cloud.looker.com/explore/yj_test/calculation?fields=calculation.sample_subcategory,calculation.Discount&limit=500&column_limit=50&vis=%7B%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Afalse%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22limit_displayed_rows%22%3Afalse%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined%22%3Atrue%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels%22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22hidden_pivots%22%3A%7B%7D%2C%22type%22%3A%22looker_column%22%2C%22defaults_version%22%3A1%7D&filter_config=%7B%7D&origin=share-expanded"
    label: "Sub-cateogry vs Discount"
  }

}
measure:  Quantity_sold{
  type: sum
  sql:  ${TABLE}.quantity_sold ;;
}
dimension: Segment {
  type: string
  sql: ${TABLE}.segment ;;
}
dimension: Country {
  type:  string
  map_layer_name: countries

  sql: ${TABLE}.Country ;;
}
dimension: State {
  type:  string
  sql: ${TABLE}.State ;;
  }
dimension: City {
  type:  string
  sql: ${TABLE}.City ;;
  }
dimension: OrderMonth {
  type: string
  sql: ${TABLE}.Order_Month ;;
}
measure: total_customer {
  type: sum
  sql: ${TABLE}.total_customers ;;
  value_format: "0.00"

}

measure: total_orders {
  type: sum
  sql: ${TABLE}.total_orders ;;
  value_format: "0.00"

}

measure: total_profit {
  type: sum
  sql: ${TABLE}.total_profit ;;
  value_format: "0.00"
}
measure: total_sales {
  type: sum
  sql: ${TABLE}.total_sales ;;
  value_format: "0.00"
}
dimension: customer_lifetime_value_segmentation {
  type: string
  sql: ${TABLE}.customer_lifetime_value_segmentation ;;
}
measure: sales_per_customer {
  type: number
  sql: ${TABLE}.sales_per_customer ;;
}

measure: days_to_ship {
  type: number
  sql: ${TABLE}.days_to_ship ;;
}

  measure: Profit_ratio {
    type: number
    sql: ${TABLE}.Profit_ratio ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  dimension_group: sample_order_date {
    type: time
    datatype: date
    timeframes: [month, month_name, year, date, raw, time, quarter]
    sql: ${TABLE}.sample_order_date ;;
  }
parameter: Select_timeframe {
  type: unquoted
  allowed_value: {
    value: "Year"
    label: "year"
  }
  allowed_value: {
    value: "Month"
    label: "Month"
  }
  allowed_value: {
    value: "Quarter"
    label: "Quarter"
  }
}
dimension: order_date {
sql:
  {% if Select_timeframe._parameter_value == 'Year'%}
  order_year
  {% elsif Select_timeframe._parameter_value == 'Month'%}
  order_month
  {% else %}
  order_quarter
  {% endif %};;
}
  dimension: sample_ship_date {
    type: date
    datatype: date
    sql: ${TABLE}.sample_ship_date ;;
  }

  dimension: sample_sales {
    type: number
    sql: ${TABLE}.sample_sales ;;
  }

  dimension: sample_profit {
    type: number
    sql: ${TABLE}.sample_profit ;;
  }

  dimension: sample_customer_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.sample_customer_id ;;
  }

  dimension: sample_order_id {
    type: string
    sql: ${TABLE}.sample_order_id ;;
  }

  dimension: sample_category {
    type: string
    sql: ${TABLE}.sample_category ;;
  }

  dimension: sample_subcategory {
    type: string
    sql: ${TABLE}.sample_subcategory ;;
  }

  dimension: sample_count {
    type: number
    sql: ${TABLE}.sample_count ;;
  }

  set: detail {
    fields: [
      sample_order_date_date,
      sample_ship_date,
      sample_sales,
      sample_profit,
      sample_customer_id,
      sample_order_id,
      sample_category,
      sample_subcategory,
      sample_count
    ]
  }
}
