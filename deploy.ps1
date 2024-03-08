$ErrorActionPreference = "Stop"
New-AzResourceGroup -Name 'TestRG' -Location 'Central US' -Tag @{'RG'='APP'}
