$ErrorActionPreference = "Stop"
New-AzResourceGroup -Name 'TestRG' -Location 'Central US' -Tag @{'RG'='APP'}
New-AzResourceGroupDeployment -Name 'DeployTest' -ResourceGroupName 'TestRG' -TemplateFile './main.bicep'