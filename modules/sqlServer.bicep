@description('region to deploy the resources')
param location string = resourceGroup().location
@description('solution ID to make resource name unique')
param solutionId string
@secure()
@description('user login for sql server admin')
param sqlServerAdminLogin string

@secure()
@description('sql server admin password')
param sqlServerAdminPassword string

@description('sku for sql server')
param sqDatabaseSku object

var sqlDatabaseName = 'Employees'

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

