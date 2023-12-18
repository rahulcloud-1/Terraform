
resource "azurerm_resource_group" "il-app-service" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = var.appserviceplan_name
  location            = azurerm_resource_group.il-app-service.location
  resource_group_name = azurerm_resource_group.il-app-service.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = var.Webapp_name
  location              = azurerm_resource_group.il-app-service.location
  resource_group_name   = azurerm_resource_group.il-app-service.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
}


resource "azurerm_storage_account" "stracc" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.il-app-service.name
  location                 = azurerm_resource_group.il-app-service.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.server_name
  resource_group_name          = azurerm_resource_group.il-app-service.name
  location                     = azurerm_resource_group.il-app-service.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "sqlDB" {
  name           = var.sqldb_name
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  
}


