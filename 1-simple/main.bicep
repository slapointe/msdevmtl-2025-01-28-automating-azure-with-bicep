@allowed([
  'dev'
  'qa'
  'stg'
  'prod'
])
param environmentCode string
param appInsightsLocation string = 'canadacentral'
param projectName string = 'msdevmtl'
param unused string

var namingSuffix = uniqueString(resourceGroup().id, projectName)
var namingPrefix = '${projectName}-${environmentCode}'
var appInsightsName = '${namingPrefix}-ai-all-${namingSuffix}'

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: appInsightsLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

