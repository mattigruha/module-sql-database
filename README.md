# Module to create a SQL Database, SQL Server and auditing policy for the SQL Server

## Requirements

| Name | Version |
|------|---------|
| [terraform](#requirement\_terraform) | >= 1.0.0 |
| [azurerm](#requirement\_azurerm) | >= 3.0.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| [azurerm](#provider\_azurerm) | 3.85.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_server.db_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.sql_srv_audit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [ad\_administrator\_login\_username](#input\_ad\_administrator\_login\_username) | Login username of the Azure AD administrator (optional) | `string` | `null` | no |
| [ad\_administrator\_object\_id](#input\_ad\_administrator\_object\_id) | Object ID of the Azure AD administrator (optional) | `string` | `null` | no |
| [ad\_administrator\_tenant\_id](#input\_ad\_administrator\_tenant\_id) | Tenant ID of the Azure AD administrator (optional) | `string` | `null` | no |
| [admin\_login](#input\_admin\_login) | Administrator login for the SQL Server | `string` | n/a | yes |
| [admin\_password](#input\_admin\_password) | Administrator password for the SQL Server | `string` | n/a | yes |
| [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Specifies whether or not Azure Active Directory only authentication is enabled. Defaults to true. | `bool` | `true` | no |
| [backup\_interval\_in\_hours](#input\_backup\_interval\_in\_hours) | (Required) Point In Time Restore configuration. Value has to be between 1 and 240. | `number` | n/a | yes |
| [collation](#input\_collation) | Collation of the database | `string` | `"SQL_Latin1_General_CP1_CI_AS"` | no |
| [database\_name](#input\_database\_name) | Name of the database | `string` | n/a | yes |
| [db\_retention\_days](#input\_db\_retention\_days) | (Required) Point In Time Restore configuration. Value has to be between 1 and 35. | `number` | n/a | yes |
| [identity\_ids](#input\_identity\_ids) | List of user assigned identity ids | `set(string)` | `[]` | no |
| [identity\_type](#input\_identity\_type) | Type of identity. Defaults to SystemAssigned. Possible values are UserAssigned. | `string` | `"SystemAssigned"` | no |
| [ledger\_enabled](#input\_ledger\_enabled) | Specifies whether or not the database is a ledger database. Defaults to false. | `bool` | `false` | no |
| [license\_type](#input\_license\_type) | License type of the database | `string` | `"LicenseIncluded"` | no |
| [location](#input\_location) | The location where the resource group is located | `string` | `"West Europe"` | no |
| [max\_size\_gb](#input\_max\_size\_gb) | Maximum size of the database | `number` | n/a | yes |
| [outbound\_network\_restriction\_enabled](#input\_outbound\_network\_restriction\_enabled) | Allow outbound network access | `bool` | `false` | no |
| [public\_network\_access](#input\_public\_network\_access) | Allow public network access | `bool` | `false` | no |
| [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| [sku\_name](#input\_sku\_name) | Specifies the name of the SKU used by the database. For example, GP\_S\_Gen5\_2, HS\_Gen4\_1, BC\_Gen5\_2, ElasticPool, Basic, S0, P2 ,DW100c, DS100. Defaults to S0. | `string` | `"S0"` | no |
| [sql\_server\_name](#input\_sql\_server\_name) | Name of the SQL Server | `string` | n/a | yes |
| [sql\_server\_version](#input\_sql\_server\_version) | Version of the SQL Server | `string` | n/a | yes |
| [storage\_account\_type](#input\_storage\_account\_type) | Specifies the storage account type to be used to store backups for this database. Valid values are Geo, Local, Zone and None. Defaults to Geo. | `string` | `"Geo"` | no |
| [tags](#input\_tags) | Tags used for the resources | `map(string)` | n/a | yes |
| [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | If UserAssigned identity type is chosen, this variable needs to be provided with the ID. | `string` | `null` | no |
| [zone\_redundant](#input\_zone\_redundant) | Specifies whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| [SQL\_server\_id](#output\_SQL\_server\_id) | The ID of the SQL Server. |
| [database\_id](#output\_database\_id) | The ID of the SQL Database. |
| [principal\_id](#output\_principal\_id) | The Principal ID for the Service Principal associated with the Identity of this SQL Server. |
| [tenant\_id](#output\_tenant\_id) | The Tenant ID for the Service Principal associated with the Identity of this SQL Server. |

# Pre-existing resources you need when using this module include a resource group, (optionally) a user assigned identity and (optionally) a random password generator for the SQL Server admin user.

# Create a new RG or use an existing one
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "test-sql-db-rg"
  location = "westeurope"

  tags = {
    Project     = ""
    Application = ""
    Environment = ""
    CreatedBy   = ""
    CreatedFor  = ""
  }
}

# Generate a random password for the SQL Server admin user (optional)
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Generate a user assigned identity resource (optional)
resource "azurerm_user_assigned_identity" "identity" {
  name                = "example-user-assigned-identity"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Calling the module and passing on the input variables
module "sql_database_module" {
  source = "../.." # Replace with the actual module source

  resource_group_name = azurerm_resource_group.rg.name
  sql_server_name     = ""
  location            = ""
  tags = {
    Project     = ""
    Application = ""
    Environment = ""
    CreatedBy   = ""
    CreatedFor  = ""
  }

  sql_server_version                   = "12.0"
  admin_login                          = ""
  admin_password                       = random_password.password.result
  public_network_access                = false
  outbound_network_restriction_enabled = false

  identity_type = "SystemAssigned" # "UserAssigned"
  # identity_ids              = [azurerm_user_assigned_identity.identity.id] # If you want to use user assigned identities, you need to create them first and pass them here
  # user_assigned_identity_id = azurerm_user_assigned_identity.identity.id
  ad_administrator_login_username = ""
  ad_administrator_object_id      = ""
  ad_administrator_tenant_id      = ""
  azuread_authentication_only     = true # Set to false if you want to only use the SQL Server admin user

  database_name        = ""
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  max_size_gb          =
  sku_name             = ""
  storage_account_type = ""
  ledger_enabled       = false
  zone_redundant       = false

  db_retention_days        = 7
  backup_interval_in_hours = 12
}
