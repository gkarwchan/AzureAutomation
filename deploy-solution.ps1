$rndm = Get-Random -Minimum -100 -Maximum 100
New-AzResourceGroupDeployment -Name "Deploy-gkar-solution" -ResourceGroupName 'DevGroup' -TemplateFile infra/main.bicep -TemplateParameterFile  infra/dev.param.json