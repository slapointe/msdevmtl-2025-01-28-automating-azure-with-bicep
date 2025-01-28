param name string = 'John Dole'
param utcValue string = utcNow()

resource scriptInTemplate1 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'scriptInTemplate1'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: utcValue
    azPowerShellVersion: '7.2'
    timeout: 'PT1H'
    arguments: '-name \\"${name}\\"'
    scriptContent: loadTextContent('myscript.ps1')
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
  }
}

resource scriptInTemplate2 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'scriptInTemplate2'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: utcValue
    azPowerShellVersion: '7.2'
    timeout: 'PT1H'
    arguments: '-textToEcho \\"${scriptInTemplate1.properties.outputs.text}\\"'
    scriptContent: '''
      param([string] $textToEcho)
      Write-Output "Received: $textToEcho"
      $transformed = '{0}. Thank you, come again!' -f $textToEcho
      $DeploymentScriptOutputs = @{
        transformedOutput = $transformed
      }
    '''
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
  }
}

output result string = scriptInTemplate2.properties.outputs.transformedOutput
