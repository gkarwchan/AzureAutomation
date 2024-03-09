param location string = resourceGroup().location
var uniqueName = uniqueString(resourceGroup().id)

@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
var storageSku = (environmentType == 'nonprod') ? 'Standard_LRS' : 'Standard_GRS'
var appPlanSku = (environmentType == 'nonprod') ? 'F1' : 'P2v3'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'storage${uniqueName}'
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'webfarm${uniqueName}'
  location: location
  sku: {
    name: appPlanSku
  }
}

resource appServiceApp 'Microsoft.Web/sites@2023-01-01' = {
  name: 'webapp${uniqueName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
