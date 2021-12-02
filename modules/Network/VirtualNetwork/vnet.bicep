
param resource_Name string= '${uniqueString(resourceGroup().id)}-vnet' 


@allowed([
  'East US'  
  'East US 2'
  'West US' 
  'North Europe'        
  'West Europe'         
  'UK South'
  'UK West' 
  'West Central US'     
  'West US 2'
])
@description('region of the key vault resource')
param location string = 'UK South'

@description('resource tags')
param tags object = {}

param vnet_addressPrefixes array //= []

var subnets = [
  // {
  //   name: 'web-subnet'
  //   subnetPrefix: '10.144.0.0/24'
  // }
  // {
  //   name: 'data-subnet'
  //   subnetPrefix: '10.144.1.0/24'
       //serviceEndpoints : [{
        //   "service": "Microsoft.Sql", //"Microsoft.Sql", "Microsoft.Storage","Microsoft.KeyVault","Microsoft.Web","Microsoft.ContainerRegistry"
        //   "locations": [
        //       "westeurope" or "*"
        //   ]
        // },
        //]
  // }
]


resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: resource_Name
  location: location
  tags: tags

  properties: {
    addressSpace: {
      addressPrefixes: vnet_addressPrefixes
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' = [for subnet in subnets: {
  name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
        serviceEndpoints: subnet.serviceEndpoints
        // networkSecurityGroup: {
        //   id: 
        // }
      }
}]

