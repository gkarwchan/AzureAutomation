

resource myStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'gkarautostorageaccount'
  location: 'useast'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
