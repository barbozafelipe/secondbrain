subscription_list = [
  "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48"
]

activity_log_alert = [
  {
    name        = "stp-dig-al-modify-nsg"
    description = "Alert triggered by Create or Update Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-nsg"
    description = "Alert triggered by Delete Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    }]
  },
  {
    name        = "stp-dig-al-modify-nsg-rules"
    description = "Alert triggered by Create or Update Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-nsg-rules"
    description = "Alert triggered by Delete Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    }]
  },
  {
    name        = "stp-dig-al-create-policy-assignment"
    description = "Alert triggered by Create Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-policy-assignment"
    description = "Alert triggered by Delete Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/delete"
    }]
  },
  {
    name        = "stp-dig-al-update-security-solution"
    description = "Alert triggered by Create or Update Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-security-solution"
    description = "Alert triggered by Delete Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/delete"
    }]
  },
  {
    name        = "stp-dig-al-update-security-policy"
    description = "Alert triggered by Update Security Policy events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/policies/write"
    }]
  },
  {
    name        = "stp-dig-al-modify-sql-firewall-rule"
    description = "Alert triggered by Create, Update or Delete SQL Server Firewall Rule events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-vm"
    description = "Alert triggered by Delete Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/delete"
    }]
  },
  {
    name        = "stp-dig-al-create-update-vm"
    description = "Alert triggered by Create or Update Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/write"
    }]
  },
  {
    name        = "stp-dig-al-deallocate-vm"
    description = "Alert triggered by Deallocate Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    }]
  },
  {
    name        = "stp-dig-al-power-off-vm"
    description = "Alert triggered by Power Off Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/powerOff/action"
    }]
  },
  {
    name        = "stp-dig-al-update-storage-account"
    description = "Alert triggered by Create or Update Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-storage-account"
    description = "Alert triggered by Delete Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/delete"
    }]
  },
  {
    name        = "stp-dig-al-update-key-vault"
    description = "Alert triggered by Update Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-key-vault"
    description = "Alert triggered by Delete Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/delete"
    }]
  },
  {
    name        = "stp-dig-al-rename-sql-database"
    description = "Alert triggered by Rename Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/move/action"
    }]
  },
  {
    name        = "stp-dig-al-delete-postgresql-database"
    description = "Alert triggered by Delete Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/delete"
    }]
  },
  {
    name        = "stp-dig-al-update-postgresql-database"
    description = "Alert triggered by Create or Update Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/write"
    }]
  },
  {
    name        = "stp-dig-al-create-update-sql-database"
    description = "Alert triggered by Create/Update Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-sql-database"
    description = "Alert triggered by Delete Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/delete"
    }]
  },
  {
    name        = "stp-dig-al-delete-load-balancer"
    description = "Alert triggered by Delete Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/delete"
    }]
  },
  {
    name        = "stp-dig-al-update-load-balancer"
    description = "Alert triggered by Create or Update Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-mysql-database"
    description = "Alert triggered by Delete Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/delete"
    }]
  },
  {
    name        = "stp-dig-al-update-mysql-database"
    description = "Alert triggered by Create/Update Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/write"
    }]
  },
  {
    name        = "stp-dig-al-update-public-ip"
    description = "Alert triggered by Create or Update Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/write"
    }]
  },
  {
    name        = "stp-dig-al-delete-public-ip"
    description = "Alert triggered by Delete Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/delete"
    }]
  }
]