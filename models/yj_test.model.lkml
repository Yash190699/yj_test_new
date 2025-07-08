connection: "test_bq_yj"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: yj_test_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: yj_test_default_datagroup

explore: sample {}
explore: calculation {}
