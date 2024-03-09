param location string = resourceGroup().location
var uniqueName = uniqueString(resourceGroup().id)

@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
var storageSku = (environmentType == 'nonprod') ? 'Standard_LRS' : 'Standard_GRS'

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

module appService 'modules/appService.bicep'={
  name: 'appService'
  params: {
    location: location
    uniqueName: uniqueName
    environmentType: environmentType,
    webAppName: 'webapp${uniqueName}'
  }
}

output appServiceHostName string = appService.outputs.appServiceHostName
