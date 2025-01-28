targetScope = 'resourceGroup'

module bicepModule '../_modules/appservices.bicep' = {
  name: 'testBicepDeploy'
  params: {
    skuCapacity: 1
    skuName: 'F1'
  }
}

module armTemplateModule '../_modules/reference-template.json' = {
  name: 'testArmDeploy'
  params: {
    resourceType: 'Microsoft.Web/sites'
    resourceName: bicepModule.outputs.webSiteResource.properties.name
    apiVersion: '2022-03-01'
  }
}

output armTemplateModuleOutput object = armTemplateModule.outputs.resource
output armTemplateModuleOutputFull object = armTemplateModule.outputs.resourceFull
