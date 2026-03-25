project_name: "ecomm_product"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }

remote_dependency: ecomm_hub {
  url: "git@github.com:brettguenther/ecomm_hub.git"
  ref: "3a8b0346ae86c725efee1f96fdf89076e0e3fff5"
  override_constant: HIGH_REVENUE_THRESHOLD {
    value: "500"
  }
  override_constant: BUSINESS_UNIT_NAME {
    value: "Product"
  }
}
