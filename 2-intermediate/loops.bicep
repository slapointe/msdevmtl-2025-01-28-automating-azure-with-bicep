param location string = resourceGroup().location
param storageCount int = 2

var itemCount = 3
var stringArray = [for i in range(0, itemCount): 'item${(i + 1)}']

var subnets = [
  {
    name: 'api'
    subnetPrefix: '10.144.0.0/24'
  }
  {
    name: 'worker'
    subnetPrefix: '10.144.1.0/24'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: 'vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.144.0.0/20'
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}

resource storageAcct 'Microsoft.Storage/storageAccounts@2023-05-01' = [for i in range(0, storageCount): {
  name: '${i}storage${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}]

output loopResult array = stringArray

output storageInfo array = [for i in range(0, storageCount): {
  id: storageAcct[i].id
  blobEndpoint: storageAcct[i].properties.primaryEndpoints.blob
  status: storageAcct[i].properties.statusOfPrimary
}]
