variable "resource_group_name" {
  type = string
  description = "Name of the resource group in Azure"
}

variable "resource_group_location" {
  type = string
  description = "Location of the resource group in Azure"
}

variable "app_service_plan_name" {
  type = string
  description = "Name of the App Service Plan in Azure"
}

variable "app_service_name" {
  type = string
  description = "Name of the App Service in Azure"  
}

variable "sql_server_name" {
  type = string
  description = "Name of the SQL Server in Azure"
}

variable "sql_database_name" {
  type = string
  description = "Name of the SQL Database in Azure"
}

variable "sql_server_administrator_login" {
  type = string
  description = "Administrator login for the SQL Server in Azure"
}

variable "sql_server_administrator_login_password" {
  type = string
  description = "Administrator login password for the SQL Server in Azure"
}

variable "firewall_rule_name" {
  type = string
  description = "Name of the firewall rule for the SQL Server in Azure"
}

variable "repo_url" {
  type = string
  description = "URL of the GitHub repository"
}

variable "app_service_plan_sku_name" {
  type = string
  description = "SKU name of the App Service Plan in Azure"
} 

variable "subscription_id" {
  type = string
  description = "Subscription ID of the Azure account"
}

variable "random_integer_min_value" {
  type = number
  description = "Minimum value for the random integer"
}

variable "random_integer_max_value" {
  type = number
  description = "Maximum value for the random integer"
}
