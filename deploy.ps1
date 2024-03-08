$ErrorActionPreference = "Stop"
Connect-AzAccount
Set-AzContext -SubscriptionName 'Enter your subscription name here'
New-AzResourceGroup -Name 'TestRG' -Location 'Central US' -Tag @{'RG'='APP'}
