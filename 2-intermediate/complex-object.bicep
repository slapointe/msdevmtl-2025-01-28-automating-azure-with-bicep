param routeArray array = [
  'OnPrem1'
  'OnPrem2'
]

var nativeArray = {
  OnPrem1: {
    AddressPrefix: '192.168.0.0/16'
    NextHopType: 'VirtualNetworkGateway'
    NextHopIpAddress: null    
  }
  OnPrem2: {
    AddressPrefix: '10.0.1.0/24'
    NextHopType: 'VirtualAppliance'
    NextHopIpAddress: '10.200.1.1'
  }
}

//Array in JSON String
var jsonString = '''
{
  "OnPrem1": {
    "AddressPrefix": "192.168.0.0/16",
    "NextHopType": "VirtualNetworkGateway",
    "NextHopIpAddress": null
  },
  "OnPrem2": {
    "AddressPrefix": "10.0.1.0/24",
    "NextHopType": "VirtualAppliance",
    "NextHopIpAddress": "10.200.1.1"
  }
}
'''
#disable-next-line no-unused-vars
var jsonArray = json(jsonString)

output newObject array = [for (name, i) in routeArray: {
  name: name
  AddressPrefix: nativeArray[name].AddressPrefix
  NextHopType: nativeArray[name].NextHopType
  NextHopIpAddress: nativeArray[name].NextHopIpAddress  
}]
