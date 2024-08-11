output "SQL_server_id" {
  description = "The ID of the SQL Server."
  value       = azurerm_mssql_server.db_server.id
}

output "database_id" {
  description = "The ID of the SQL Database."
  value       = azurerm_mssql_database.database.id
}

output "principal_id" {
  description = "The Principal ID for the Service Principal associated with the Identity of this SQL Server."
  value       = azurerm_mssql_server.db_server.identity[0].principal_id
}

output "tenant_id" {
  description = "The Tenant ID for the Service Principal associated with the Identity of this SQL Server."
  value       = azurerm_mssql_server.db_server.identity[0].tenant_id
}
