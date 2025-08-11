connection: "test_bq_yj"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: yj_test_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
access_grant: view_calculations {
  user_attribute: dash_access
  allowed_values: ["allow_access"]
}
persist_with: yj_test_default_datagroup

explore: sample {}
explore: calculation {
access_filter: {
  field: Region
  user_attribute: region
  }
}

# access_grant: Region_restrict {
  # allowed_values: ["EMEA","South"]
  # user_attribute: region
# }
