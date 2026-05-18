subscription_list = [
  "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8"
]

activity_log_alert = [
  {
    name        = "stp-cpp-al-modify-nsg-prd"
    description = "Alert triggered by Create or Update Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-nsg-prd"
    description = "Alert triggered by Delete Network Security Group events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    }]
  },
  {
    name        = "stp-cpp-al-modify-nsg-rules-prd"
    description = "Alert triggered by Create or Update Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-nsg-rules-prd"
    description = "Alert triggered by Delete Network Security Group rules"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    }]
  },
  {
    name        = "stp-cpp-al-create-policy-assignment-prd"
    description = "Alert triggered by Create Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-policy-assignment-prd"
    description = "Alert triggered by Delete Policy Assignment events"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Authorization/policyAssignments/delete"
    }]
  },
  {
    name        = "stp-cpp-al-update-security-solution-prd"
    description = "Alert triggered by Create or Update Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-security-solution-prd"
    description = "Alert triggered by Delete Security Solution events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/securitySolutions/delete"
    }]
  },
  {
    name        = "stp-cpp-al-update-security-policy-prd"
    description = "Alert triggered by Update Security Policy events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Security/policies/write"
    }]
  },
  {
    name        = "stp-cpp-al-modify-sql-firewall-rule-prd"
    description = "Alert triggered by Create, Update or Delete SQL Server Firewall Rule events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-vm-prd"
    description = "Alert triggered by Delete Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/delete"
    }]
  },
  {
    name        = "stp-cpp-al-create-update-vm-prd"
    description = "Alert triggered by Create or Update Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/write"
    }]
  },
  {
    name        = "stp-cpp-al-deallocate-vm-prd"
    description = "Alert triggered by Deallocate Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    }]
  },
  {
    name        = "stp-cpp-al-power-off-vm-prd"
    description = "Alert triggered by Power Off Virtual Machine events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Compute/virtualMachines/powerOff/action"
    }]
  },
  {
    name        = "stp-cpp-al-update-storage-account-prd"
    description = "Alert triggered by Create or Update Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-storage-account-prd"
    description = "Alert triggered by Delete Storage Account events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Storage/storageAccounts/delete"
    }]
  },
  {
    name        = "stp-cpp-al-update-key-vault-prd"
    description = "Alert triggered by Update Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-key-vault-prd"
    description = "Alert triggered by Delete Key Vault events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.KeyVault/vaults/delete"
    }]
  },
  {
    name        = "stp-cpp-al-rename-sql-database-prd"
    description = "Alert triggered by Rename Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/move/action"
    }]
  },
  {
    name        = "stp-cpp-al-delete-postgresql-database-prd"
    description = "Alert triggered by Delete Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/delete"
    }]
  },
  {
    name        = "stp-cpp-al-update-postgresql-database-prd"
    description = "Alert triggered by Create or Update Azure PostgreSQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforPostgreSQL/servers/databases/write"
    }]
  },
  {
    name        = "stp-cpp-al-create-update-sql-database-prd"
    description = "Alert triggered by Create/Update Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-sql-database-prd"
    description = "Alert triggered by Delete Azure SQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/delete"
    }]
  },
  {
    name        = "stp-cpp-al-delete-load-balancer-prd"
    description = "Alert triggered by Delete Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/delete"
    }]
  },
  {
    name        = "stp-cpp-al-update-load-balancer-prd"
    description = "Alert triggered by Create or Update Load Balancer events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/loadBalancers/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-mysql-database-prd"
    description = "Alert triggered by Delete Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/delete"
    }]
  },
  {
    name        = "stp-cpp-al-update-mysql-database-prd"
    description = "Alert triggered by Create/Update Azure MySQL Database events"
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.DBforMySQL/servers/databases/write"
    }]
  },
  {
    name        = "stp-cpp-al-update-public-ip-prd"
    description = "Alert triggered by Create or Update Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/write"
    }]
  },
  {
    name        = "stp-cpp-al-delete-public-ip-prd"
    description = "Alert triggered by Delete Public IP Address"
    criteria = [{
      category       = "Policy"
      operation_name = "Microsoft.Network/publicIPAddresses/delete"
    }]
  }
]