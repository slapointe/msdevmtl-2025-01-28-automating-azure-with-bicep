@allowed([
  'dev'
  'qa'
  'stg'
  'prod'
])
param environmentCode string
param appInsightsLocation string = 'canadacentral'
param location string = resourceGroup().location

var config = loadJsonContent('../_configs/config.json')

var configOverrides = {
  tags: {
    environment: environmentCode
  }
}
var computedConfig = union(config, configOverrides)

var namingSuffix = uniqueString(resourceGroup().id, config.projectName)
var namingPrefix = '${config.projectName}-${environmentCode}'
var appInsightsName = '${namingPrefix}-ai-all-${namingSuffix}'
var appServicePlanName = '${namingPrefix}-asp-all-${namingSuffix}'
var appServiceWebAppName = '${namingPrefix}-as-web-${namingSuffix}'

var appServicePlanSkuName = environmentCode == 'prod' ? 'P1V3' : 'F1'

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: appInsightsLocation
  kind: 'web'
  tags: computedConfig.tags
  properties: {
    Application_Type: 'web'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  tags: computedConfig.tags
  sku: {
    name: appServicePlanSkuName
    capacity: 1
  }
}

resource webApplication 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceWebAppName
  location: location
  tags: union(computedConfig.tags, {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  })
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AppInsightsIntrumentationKey'
          value: appInsightsComponents.properties.InstrumentationKey
        }
      ]
    }
  }
}

output appInsightsConnectionString string = appInsightsComponents.properties.ConnectionString
