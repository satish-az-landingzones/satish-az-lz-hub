# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Myle-Solutions"
}

variable "default_location" {
  type    = string
  default = "eastus"
}

variable "subscription_alias_name" {

}

variable "subscription_display_name" {}
variable "subscription_workload" {}
variable "subscription_management_group_id" {}
variable "subscription_billing_scope" {}