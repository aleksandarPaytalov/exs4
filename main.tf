terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "alex-taskboard-rg" {
  name     = "${var.resource_group_name}${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "random_integer" "ri" {
  min = var.random_integer_min_value
  max = var.random_integer_max_value
}

resource "azurerm_service_plan" "taskboard-service-plan" {
  name                = "${var.app_service_plan_name}${random_integer.ri.result}"
  location            = azurerm_resource_group.alex-taskboard-rg.location
  resource_group_name = azurerm_resource_group.alex-taskboard-rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku_name
}

resource "azurerm_linux_web_app" "alwa" {
  name                = "${var.app_service_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.alex-taskboard-rg.name
  location            = azurerm_resource_group.alex-taskboard-rg.location
  service_plan_id     = azurerm_service_plan.taskboard-service-plan.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false

  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.taskboard-server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.taskboard-db.name};User ID=${azurerm_mssql_server.taskboard-server.administrator_login};Password=${azurerm_mssql_server.taskboard-server.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "taskboard-source" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = var.repo_url
  branch                 = "main"
  use_manual_integration = false
}

resource "azurerm_mssql_server" "taskboard-server" {
  name                         = "${var.sql_server_name}${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.alex-taskboard-rg.name
  location                     = azurerm_resource_group.alex-taskboard-rg.location
  version                      = "12.0"
  administrator_login          = var.sql_server_administrator_login
  administrator_login_password = var.sql_server_administrator_login_password

  tags = {
    environment = "development"
  }
}

resource "azurerm_mssql_database" "taskboard-db" {
  name           = "${var.sql_database_name}${random_integer.ri.result}"
  server_id      = azurerm_mssql_server.taskboard-server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "taskboard-firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.taskboard-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
