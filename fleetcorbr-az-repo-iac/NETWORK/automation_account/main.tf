resource "azurerm_automation_account" "res-1" {
  location            = "brazilsouth"
  name                = "plt-net-aa-fw-stst"
  resource_group_name = "plt-net-aut-rg"
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_automation_job_schedule" "res-22" {
  automation_account_name = "plt-net-aa-fw-stst"
  parameters = {
    action                        = "\"Start\""
    azurefirewallname             = "\"plt-net-afw\""
    azurefirewallpipname          = "\"plt-net-pip-afw\""
    azurefirewallpipresourcegroup = "\"plt-net-rg\""
    azurefirewallresourcegroup    = "\"plt-net-rg\""
    azurefirewallvnetname         = "\"plt-net-vnet\""
  }
  resource_group_name = "plt-net-aut-rg"
  runbook_name        = azurerm_automation_runbook.res-128.name
  schedule_name       = "StartFirewall"
  depends_on = [
    azurerm_automation_account.res-1,
  ]
}
resource "azurerm_automation_job_schedule" "res-23" {
  automation_account_name = "plt-net-aa-fw-stst"
  parameters = {
    action                        = "\"Stop\""
    azurefirewallname             = "\"plt-net-afw\""
    azurefirewallpipname          = "\"plt-net-pip-afw\""
    azurefirewallpipresourcegroup = "\"plt-net-rg\""
    azurefirewallresourcegroup    = "\"plt-net-rg\""
    azurefirewallvnetname         = "\"plt-net-vnet\""
  }
  resource_group_name = "plt-net-aut-rg"
  runbook_name        = azurerm_automation_runbook.res-128.name
  schedule_name       = "StopFirewall"
  depends_on = [
    azurerm_automation_account.res-1,
  ]
}
resource "azurerm_automation_schedule" "res-124" {
  automation_account_name = "plt-net-aa-fw-stst"
  frequency               = "Day"
  name                    = "StartFirewall"
  resource_group_name     = "plt-net-aut-rg"
  timezone                = "America/Sao_Paulo"
  depends_on = [
    azurerm_automation_account.res-1,
  ]
}
resource "azurerm_automation_schedule" "res-125" {
  automation_account_name = "plt-net-aa-fw-stst"
  frequency               = "Day"
  name                    = "StopFirewall"
  resource_group_name     = "plt-net-aut-rg"
  timezone                = "America/Sao_Paulo"
  depends_on = [
    azurerm_automation_account.res-1,
  ]
}
resource "azurerm_automation_runbook" "res-128" {
  automation_account_name = "plt-net-aa-fw-stst"
  content                 = "Param(        \r\n        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] \r\n        [String]\r\n        $AzureFirewallName, \r\n         \r\n        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] \r\n        [String]\r\n        $AzureFirewallResourceGroup, \r\n         \r\n        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] \r\n        [String]\r\n        $AzureFirewallVnetName, \r\n \r\n        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] \r\n        [String]\r\n        $AzureFirewallPipName, \r\n \r\n        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] \r\n        [String]\r\n        $AzureFirewallPipResourceGroup, \r\n \r\n        [Parameter(Mandatory=$true)][ValidateSet(\"Start\",\"Stop\")] \r\n        [String]\r\n        $Action\r\n)\r\n\r\n# Ensures you do not inherit an AzContext in your runbook\r\nDisable-AzContextAutosave -Scope Process\r\n\r\ntry\r\n{\r\n    \"Logging in to Azure...\"\r\n\r\n    # Connect to Azure with system-assigned managed identity\r\n    $AzureContext = (Connect-AzAccount -Identity).context\r\n\r\n    # Set and store context\r\n    $AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext\r\n}\r\ncatch {\r\n    Write-Error -Message $_.Exception\r\n    throw $_.Exception\r\n}\r\n\r\n# Get Firewall\r\n$azfw = Get-AzFirewall -Name $AzureFirewallName -ResourceGroupName $AzureFirewallResourceGroup\r\n \r\nif($Action -eq \"Stop\") { \r\n    \"Stopping Azure Firewall $AzureFirewallName\"\r\n    $azfw.Deallocate() \r\n     \r\n        Set-AzFirewall -AzureFirewall $azfw\r\n \r\n} elseif ($Action -eq \"Start\") {\r\n    $vnet = Get-AzVirtualNetwork -ResourceGroupName $AzureFirewallResourceGroup -Name $AzureFirewallVnetName\r\n    $publicip = Get-AzPublicIpAddress -Name $AzureFirewallPipName -ResourceGroupName $AzureFirewallPipResourceGroup\r\n    $azfw.Allocate($vnet,$publicip) \r\n     \r\n        Set-AzFirewall -AzureFirewall $azfw\r\n}"
  location                = "brazilsouth"
  log_progress            = false
  log_verbose             = false
  name                    = "StartStopAzureFirewall"
  resource_group_name     = "plt-net-aut-rg"
  runbook_type            = "PowerShell"
  depends_on = [
    azurerm_automation_account.res-1,
  ]
}
