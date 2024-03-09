$ErrorActionPreference = "Stop"
New-AzResourceGroup -Name 'TestRG' -Location 'Central US' -Force -Tag @{'RG'='APP'}
New-AzResourceGroupDeployment -Name 'DeployTest' -ResourceGroupName 'TestRG' -TemplateFile './main.bicep'