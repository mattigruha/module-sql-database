# Creating of the database server
resource "azurerm_mssql_server" "db_server" {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  version                              = var.sql_server_version
  administrator_login                  = var.admin_login
  administrator_login_password         = var.admin_password # Generating a random password with the random_password resource
  minimum_tls_version                  = "1.2"
  public_network_access_enabled        = var.public_network_access                # false
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled # false

  # The dynamic block will iterate over the identity_ids list and create an user assigned identity for each id in the list. If the identity_type is SystemAssigned,
  # then the identity_ids list will be empty and the identity will be SystemAssigned.
  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? var.identity_ids : [var.identity_type]

    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? [identity.key] : []
    }
  }

  azuread_administrator {
    login_username              = var.ad_administrator_login_username
    object_id                   = var.ad_administrator_object_id
    tenant_id                   = var.ad_administrator_tenant_id
    azuread_authentication_only = var.azuread_authentication_only
  }

  primary_user_assigned_identity_id = var.identity_type == "UserAssigned" ? var.user_assigned_identity_id : null

  lifecycle {
    ignore_changes = [tags]
  }
}

# Creating the database itself
resource "azurerm_mssql_database" "database" {
  name                 = var.database_name
  server_id            = azurerm_mssql_server.db_server.id
  collation            = var.collation
  license_type         = var.license_type
  max_size_gb          = var.max_size_gb
  sku_name             = var.sku_name
  storage_account_type = var.storage_account_type
  ledger_enabled       = var.ledger_enabled
  zone_redundant       = var.zone_redundant
  tags                 = var.tags

  short_term_retention_policy {
    retention_days           = var.db_retention_days
    backup_interval_in_hours = var.backup_interval_in_hours
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [azurerm_mssql_server.db_server]
}

# Auditing policy for the SQL Server
resource "azurerm_mssql_server_extended_auditing_policy" "sql_srv_audit" {
  server_id              = azurerm_mssql_server.db_server.id
  log_monitoring_enabled = true
  enabled                = true

  depends_on = [azurerm_mssql_server.db_server]
}
