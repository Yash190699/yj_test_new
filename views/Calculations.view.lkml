view: calculation {

  required_access_grants: [view_calculations]
  derived_table: {
    sql: SELECT
          sample.OrderDate  AS sample_order_date,
          sample.ShipDate  AS sample_ship_date,
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
          sample.Region As Region,
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
          EXTRACT(quarter FROM sample.OrderDate) AS order_quarter,
          RANK() OVER(ORDER BY COUNT(*) DESC) as rank


      FROM New_yj.sample  AS sample
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
      16,
      17
      ORDER BY
      1 DESC
      ;;
  }

  dimension: CustomerName {
    type: string
    sql: ${TABLE}.CustomerName ;;
  }
  dimension: Region {
    type: string
    sql: ${TABLE}.Region ;;
  }
  measure: Discount {
    type: average
    sql: ${TABLE}.Discount ;;
  }
  dimension: Product_name {
    type: string
    sql: ${TABLE}.Product_Name ;;
  }
  measure:  Quantity_sold{
    type: sum
    sql:  ${TABLE}.quantity_sold ;;
  }
  dimension: Segment {
    type: string
    sql: ${TABLE}.segment ;;
    drill_fields: [CustomerName,sample_customer_id,total_sales,total_profit]
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
  parameter: Top_Products {
    type: unquoted
    allowed_value: {
      value: "Top 5"
      label: "Top5"
    }
    allowed_value: {
      value: "Top 10"
      label: "Top 10"
    }
    allowed_value: {
      value: "Top 15"
      label: "Top 15"
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
    drill_fields: [sample_subcategory, total_profit, total_sales]
  }

  dimension: sample_subcategory {
    type: string
    sql: ${TABLE}.sample_subcategory ;;
  }

  dimension: sample_count {
    type: number
    sql: ${TABLE}.sample_count ;;
  }
  measure: Same_period_last_year{
    type:  period_over_period
    based_on: total_sales
    based_on_time: sample_order_date_date
    kind: previous
    period: year
    value_format: "0.00"
  }
  measure: Difference_from_last_year{
    type:  period_over_period
    based_on: total_sales
    based_on_time: sample_order_date_date
    kind: difference
    period: year
    value_format: "0.00"

  }
  measure: Percent_change {
    type:  period_over_period
    based_on: total_sales
    based_on_time: sample_order_date_date
    kind: relative_change
    period: year
    value_format: "0.00%"

  }
  set: drill {
    fields: [
      sample_subcategory,Discount
    ]
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
