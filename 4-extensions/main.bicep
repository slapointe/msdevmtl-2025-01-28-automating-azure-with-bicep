extension microsoftGraphV1

// resource exampleGroup 'Microsoft.Graph/groups@v1.0' = {
//   name: 'exampleGroup'
//   properties: {
//     displayName: 'Example Group'
//     mailEnabled: false
//     mailNickname: 'exampleGroup'
//     securityEnabled: true
//   }
// }

resource demoApp 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: 'msdevmtl-bicep-demoapp'
  displayName: 'MSDEVMTL Bicep Demo App'
  identifierUris: [
  ]
  requiredResourceAccess: [
    {
      resourceAppId: '00000003-0000-0000-c000-000000000000'
      resourceAccess: [
        {
          id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d'
          type: 'Scope'
        }
      ]
    }
  ]
}

output demoAppOutput object = demoApp
