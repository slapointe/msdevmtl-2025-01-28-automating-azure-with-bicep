targetScope = 'managementGroup'

@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param deployerPrincipalType string = 'User'
param principalId string = deployer().objectId
@secure()
param secretValue string = 'MySecretValue'

// Create a unique dns name for the Key Vault that include versioning since the name must be unique across Azure and sometimes side by side deployments are needed
var keyVaultName = 'msdevmtldemo${uniqueString(subscription().id, resourceGroup().id, 'Version1')}'
// Ensure the Key Vault name is maximum 24 characters
var keyVaultNameSafe = substring(keyVaultName, 0, min(23, length(keyVaultName)))

module deployment './interesting-functions-child-deployment.bicep' = {
  name: 'main'
  scope: 'managementGroup'
  params: {
    deployerPrincipalType: deployerPrincipalType
    principalId: principalId
    secretValue: secretValue
    keyVaultNameSafe: keyVaultNameSafe
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultNameSafe
  location: 'canadacentral'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }

    enableRbacAuthorization: true
    enableSoftDelete: false
    tenantId: tenant().tenantId
  }
}  

@description('This is the built-in Key Vault Administrator role. See https://learn.microsoft.com/en-ca/azure/role-based-access-control/built-in-roles/security#key-vault-administrator')
resource keyVaultAdministratorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: keyVault
  name: '00482a5a-887f-4fb3-b363-3b7fe8e74483'
}

resource keyVaultDeployerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVault
  name: guid(resourceGroup().id, principalId, keyVaultAdministratorRoleDefinition.id)
  properties: {
    principalId: deployer().objectId
    roleDefinitionId: keyVaultAdministratorRoleDefinition.id
    principalType: deployerPrincipalType
  }
}

resource KeyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'secret1'
  properties: {
    value: secretValue
  }
  dependsOn: [
    keyVaultDeployerRoleAssignment
  ]
}

output deployer object = deployer()
output deployment object = deployment()
output environment object = environment()
output managementGroup object = managementGroup()
