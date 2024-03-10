@description('region to deploy the resources')
param location string = resourceGroup().location

@description('environment name')
@allowed([
  'dev'
  'test'
  'pre'
  'prod'
])
param environmentName string

@description('app service plan instance count')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int
@description('app service sku')
param appServiceSku object
@description('storage account sku')
param storageSku string


@description('user login for sql server admin')
param sqlServerAdminLogin string

@secure()
@description('sql server admin password')
param sqlServerAdminPassword string

@description('sku for sql server')
param sqDatabaseSku object

var solutionId = '${environmentName}${uniqueString(resourceGroup().id)}'


@description('')
module sqlServer 'modules/sqlServer.bicep' = {
  name: 'sqlServer'
  params: {
    location: location
    solutionId: solutionId
    sqDatabaseSku: sqDatabaseSku
    sqlServerAdminLogin: sqlServerAdminLogin
    sqlServerAdminPassword: sqlServerAdminPassword
    environmentName: environmentName
  }
}

module storageAccount 'modules/storageAccount.bicep' = {
  name: 'storageAccount'
  params: {
    location: location
    solutionId: solutionId
    storageSku: storageSku
  }
}


module appService 'modules/appService.bicep'={
  name: 'appService'
  params: {
    location: location
    solutionId: solutionId
    appServicePlanSku: appServiceSku
    appServicePlanInstanceCount: appServicePlanInstanceCount
  }
}

output appServiceHostName string = appService.outputs.appServiceHostName
