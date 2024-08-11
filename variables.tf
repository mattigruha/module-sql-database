variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "The location where the resource group is located"
  default     = "West Europe"
  type        = string
}

variable "tags" {
  description = "Tags used for the resources"
  type        = map(string)
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "public_network_access" {
  description = "Allow public network access"
  type        = bool
  default     = false
}

variable "outbound_network_restriction_enabled" {
  description = "Allow outbound network access"
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "Type of identity. Defaults to SystemAssigned. Possible values are UserAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of user assigned identity ids"
  type        = set(string)
  default     = []
}

variable "user_assigned_identity_id" {
  description = "If UserAssigned identity type is chosen, this variable needs to be provided with the ID."
  type        = string
  default     = null
}

variable "ad_administrator_login_username" {
  description = "Login username of the Azure AD administrator (optional)"
  type        = string
  default     = null
}

variable "ad_administrator_object_id" {
  description = "Object ID of the Azure AD administrator (optional)"
  type        = string
  default     = null
}

variable "ad_administrator_tenant_id" {
  description = "Tenant ID of the Azure AD administrator (optional)"
  type        = string
  default     = null
}

variable "azuread_authentication_only" {
  description = "Specifies whether or not Azure Active Directory only authentication is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "collation" {
  description = "Collation of the database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "License type of the database"
  type        = string
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  description = "Maximum size of the database"
  type        = number
}

variable "sku_name" {
  description = "Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2, HS_Gen4_1, BC_Gen5_2, ElasticPool, Basic, S0, P2 ,DW100c, DS100. Defaults to S0."
  type        = string
  default     = "S0"
}

variable "storage_account_type" {
  description = "Specifies the storage account type to be used to store backups for this database. Valid values are Geo, Local, Zone and None. Defaults to Geo."
  type        = string
  default     = "Geo"
}

variable "ledger_enabled" {
  description = "Specifies whether or not the database is a ledger database. Defaults to false."
  type        = bool
  default     = false
}

variable "zone_redundant" {
  description = "Specifies whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. Defaults to false."
  type        = bool
  default     = false
}

variable "db_retention_days" {
  description = "(Required) Point In Time Restore configuration. Value has to be between 1 and 35."
  type        = number
}

variable "backup_interval_in_hours" {
  description = "(Required) Point In Time Restore configuration. Value has to be between 1 and 240."
  type        = number
}

variable "sql_server_version" {
  description = "Version of the SQL Server"
  type        = string
}

variable "admin_login" {
  description = "Administrator login for the SQL Server"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Administrator password for the SQL Server"
  type        = string
  sensitive   = true
}
