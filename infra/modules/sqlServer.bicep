@description('region to deploy the resources')
param location string = resourceGroup().location
@description('solution ID to make resource name unique')
param solutionId string
@description('user login for sql server admin')
param sqlServerAdminLogin string
@description('environment name')
@allowed([
  'dev'
  'test'
  'pre'
  'prod'
])
param environmentName string
@secure()
@description('sql server admin password')
param sqlServerAdminPassword string

@description('sku for sql server')
param sqDatabaseSku object

var sqlDatabaseName = 'Employees'
var auditingEnabled = environmentName == 'prod' || environmentName == 'pre'

var auditStorageAccountSkuName = 'Standard_LRS'
var auditStorageAccountName = take('bearaudit${environmentName}${uniqueString(resourceGroup().id)}', 24)

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  location: location
  name: 'sql-${solutionId}'
  properties: {
    administratorLogin: sqlServerAdminLogin
    administratorLoginPassword: sqlServerAdminPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  location: location
  name: sqlDatabaseName
  sku: {
    name: sqDatabaseSku.name
    tier: sqDatabaseSku.tier
  }
}

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = if (auditingEnabled) {
  name: auditStorageAccountName
  location: location
  sku: {
    name: auditStorageAccountSkuName
  }
  kind: 'StorageV2'  
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2021-11-01-preview' = if (auditingEnabled) {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: auditingEnabled ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: auditingEnabled ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
  }
}
