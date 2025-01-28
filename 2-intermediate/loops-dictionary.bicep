param nsgValues object = {
  nsg1: {
    name: 'nsg-westus1'
    location: 'westus'
  }
  nsg2: {
    name: 'nsg-east1'
    location: 'eastus'
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = [for nsg in items(nsgValues): {
  name: nsg.value.name
  location: nsg.value.location
}]

output computedItems array = items(nsgValues)
