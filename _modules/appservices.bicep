targetScope = 'resourceGroup'

@description('App Service SKU Name')
// @allowed([
//   'F1'
//   'B1'
//   'D1'
//   'S1'
//   'S2'
//   'S3'
//   'P1V3'
//   'P2V3'
//   'P3V3'
// ])
param skuName string

@description('Number of instances in the App Service Plan')
param skuCapacity int

@description('Azure Region')
param location string = resourceGroup().location

var namePrefix = 'demo'
var namingSuffix = uniqueString(resourceGroup().id)

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: '${namePrefix}-asp-${namingSuffix}'
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource webApplication 'Microsoft.Web/sites@2024-04-01' = {
  name: '${namePrefix}-as-web-${namingSuffix}'
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output webSiteResource object = webApplication
