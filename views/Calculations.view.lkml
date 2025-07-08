
view: calculation {
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
          COUNT(sample.CustomerID) AS total_customers
      FROM `New_yj.sample`  AS sample
      GROUP BY
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8
      ORDER BY
          1 DESC
      LIMIT 500 ;;
  }


measure: total_customer {
  type: number
  sql: ${TABLE}.total_customers ;;
}

measure: total_orders {
  type: number
  sql: ${TABLE}.total_orders ;;
}

measure: total_profit {
  type: number
  sql: ${TABLE}.total_profit ;;
}
measure: total_sales {
  type: number
  sql: ${TABLE}.total_sales ;;
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

  dimension: sample_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.sample_order_date ;;
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
      sample_order_date,
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
