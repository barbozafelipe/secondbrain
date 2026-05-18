subscription_list = [
  "/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
]

activity_log_alert = [
  {
    name        = "plt-idt-al-modify-nsg"
    description = "Alert triggered by Create or Update Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-nsg"
    description = "Alert triggered by Delete Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    }]
  },
  {
    name        = "plt-idt-al-modify-nsg-rules"
    description = "Alert triggered by Create or Update Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-nsg-rules"
    description = "Alert triggered by Delete Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    }]
  },
  {
    name        = "plt-idt-al-create-policy-assignment"
    description = "Alert triggered by Create Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-policy-assignment"
    description = "Alert triggered by Delete Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/delete"
    }]
  },
  {
    name        = "plt-idt-al-update-security-solution"
    description = "Alert triggered by Create or Update Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-security-solution"
    description = "Alert triggered by Delete Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/delete"
    }]
  },
  {
    name        = "plt-idt-al-update-security-policy"
    description = "Alert triggered by Update Security Policy events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/policies/write"
    }]
  },
  {
    name        = "plt-idt-al-modify-sql-firewall-rule"
    description = "Alert triggered by Create, Update or Delete SQL Server Firewall Rule events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-vm"
    description = "Alert triggered by Delete Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/delete"
    }]
  },
  {
    name        = "plt-idt-al-create-update-vm"
    description = "Alert triggered by Create or Update Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/write"
    }]
  },
  {
    name        = "plt-idt-al-deallocate-vm"
    description = "Alert triggered by Deallocate Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    }]
  },
  {
    name        = "plt-idt-al-power-off-vm"
    description = "Alert triggered by Power Off Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/powerOff/action"
    }]
  },
  {
    name        = "plt-idt-al-update-storage-account"
    description = "Alert triggered by Create or Update Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-storage-account"
    description = "Alert triggered by Delete Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/delete"
    }]
  },
  {
    name        = "plt-idt-al-update-key-vault"
    description = "Alert triggered by Update Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-key-vault"
    description = "Alert triggered by Delete Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/delete"
    }]
  },
  {
    name        = "plt-idt-al-rename-sql-database"
    description = "Alert triggered by Rename Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/move/action"
    }]
  },
  {
    name        = "plt-idt-al-delete-postgresql-database"
    description = "Alert triggered by Delete Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/delete"
    }]
  },
  {
    name        = "plt-idt-al-update-postgresql-database"
    description = "Alert triggered by Create or Update Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/write"
    }]
  },
  {
    name        = "plt-idt-al-create-update-sql-database"
    description = "Alert triggered by Create/Update Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-sql-database"
    description = "Alert triggered by Delete Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/delete"
    }]
  },
  {
    name        = "plt-idt-al-delete-load-balancer"
    description = "Alert triggered by Delete Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/delete"
    }]
  },
  {
    name        = "plt-idt-al-update-load-balancer"
    description = "Alert triggered by Create or Update Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-mysql-database"
    description = "Alert triggered by Delete Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/delete"
    }]
  },
  {
    name        = "plt-idt-al-update-mysql-database"
    description = "Alert triggered by Create/Update Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/write"
    }]
  },
  {
    name        = "plt-idt-al-update-public-ip"
    description = "Alert triggered by Create or Update Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/write"
    }]
  },
  {
    name        = "plt-idt-al-delete-public-ip"
    description = "Alert triggered by Delete Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/delete"
    }]
  }
]