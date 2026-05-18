subscription_list = [
  "/subscriptions/936b1a91-dba6-4205-a0c5-c8e4fdf3465e"
]

activity_log_alert = [
  {
    name        = "spe-spe-al-modify-nsg-nprd"
    description = "Alert triggered by Create or Update Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-nsg-nprd"
    description = "Alert triggered by Delete Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    }]
  },
  {
    name        = "spe-spe-al-modify-nsg-rules-nprd"
    description = "Alert triggered by Create or Update Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-nsg-rules-nprd"
    description = "Alert triggered by Delete Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    }]
  },
  {
    name        = "spe-spe-al-create-policy-assignment-nprd"
    description = "Alert triggered by Create Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-policy-assignment-nprd"
    description = "Alert triggered by Delete Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/delete"
    }]
  },
  {
    name        = "spe-spe-al-update-security-solution-nprd"
    description = "Alert triggered by Create or Update Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-security-solution-nprd"
    description = "Alert triggered by Delete Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/delete"
    }]
  },
  {
    name        = "spe-spe-al-update-security-policy-nprd"
    description = "Alert triggered by Update Security Policy events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/policies/write"
    }]
  },
  {
    name        = "spe-spe-al-modify-sql-firewall-rule-nprd"
    description = "Alert triggered by Create, Update or Delete SQL Server Firewall Rule events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-vm-nprd"
    description = "Alert triggered by Delete Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/delete"
    }]
  },
  {
    name        = "spe-spe-al-create-update-vm-nprd"
    description = "Alert triggered by Create or Update Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/write"
    }]
  },
  {
    name        = "spe-spe-al-deallocate-vm-nprd"
    description = "Alert triggered by Deallocate Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    }]
  },
  {
    name        = "spe-spe-al-power-off-vm-nprd"
    description = "Alert triggered by Power Off Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/powerOff/action"
    }]
  },
  {
    name        = "spe-spe-al-update-storage-account-nprd"
    description = "Alert triggered by Create or Update Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-storage-account-nprd"
    description = "Alert triggered by Delete Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/delete"
    }]
  },
  {
    name        = "spe-spe-al-update-key-vault-nprd"
    description = "Alert triggered by Update Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-key-vault-nprd"
    description = "Alert triggered by Delete Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/delete"
    }]
  },
  {
    name        = "spe-spe-al-rename-sql-database-nprd"
    description = "Alert triggered by Rename Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/move/action"
    }]
  },
  {
    name        = "spe-spe-al-delete-postgresql-database-nprd"
    description = "Alert triggered by Delete Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/delete"
    }]
  },
  {
    name        = "spe-spe-al-update-postgresql-database-nprd"
    description = "Alert triggered by Create or Update Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/write"
    }]
  },
  {
    name        = "spe-spe-al-create-update-sql-database-nprd"
    description = "Alert triggered by Create/Update Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-sql-database-nprd"
    description = "Alert triggered by Delete Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/delete"
    }]
  },
  {
    name        = "spe-spe-al-delete-load-balancer-nprd"
    description = "Alert triggered by Delete Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/delete"
    }]
  },
  {
    name        = "spe-spe-al-update-load-balancer-nprd"
    description = "Alert triggered by Create or Update Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-mysql-database-nprd"
    description = "Alert triggered by Delete Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/delete"
    }]
  },
  {
    name        = "spe-spe-al-update-mysql-database-nprd"
    description = "Alert triggered by Create/Update Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/write"
    }]
  },
  {
    name        = "spe-spe-al-update-public-ip-nprd"
    description = "Alert triggered by Create or Update Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/write"
    }]
  },
  {
    name        = "spe-spe-al-delete-public-ip-nprd"
    description = "Alert triggered by Delete Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/delete"
    }]
  }
]