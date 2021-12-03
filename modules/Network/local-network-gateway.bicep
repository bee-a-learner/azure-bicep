@description('name of the resource group')
param resource_name string = 'ase-${uniqueString(resourceGroup().name)}'

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
param location string = 'East US'


@description('resource tags')
param tags object = {}


param gatewayIpAddress string ='ExpressRoute'

resource gateway 'Microsoft.Network/localNetworkGateways@2021-03-01' = {
  name:  resource_name
  location: location
  tags: tags
  properties: {
      gatewayIpAddress: gatewayIpAddress
  }
}
