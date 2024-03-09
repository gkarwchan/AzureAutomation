param location string
param uniqueName string
param webAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverFarms@2023-01-01' = {
  name: 'webfarm${uniqueName}'
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceHostName string = appServiceApp.properties.defaultHostName