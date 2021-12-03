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


@description('name of the virtual network name')
param virtualNetworkName string = 'ase-${uniqueString(resourceGroup().name)}'

@description('name of the virtual network subnet')
param subnetName string = 'ase-${uniqueString(resourceGroup().name)}'

@allowed([
  'RouteBased'
  'PolicyBased'
])
param vpnType string ='RouteBased'

@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string ='Vpn'

param frontend_public_ip_name string ='pip-ulluhqqfddh4o'

param sku object = {
  capacity: 1
  name: 'Basic'
  tier: 'ErGw1AZ'
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-03-01' existing = if(!empty(frontend_public_ip_name)){
  name: frontend_public_ip_name
}

resource gateway 'Microsoft.Network/virtualNetworkGateways@2019-08-01' = {
  name:  resource_name
  location: location
  tags: tags
  properties: {
    sku: sku
    vpnType: vpnType
    gatewayType: gatewayType

    ipConfigurations: [
      {
        name: 'default'
        properties:  {
           privateIPAllocationMethod: 'Dynamic'
           publicIPAddress: {
             id: pip.id
           }
           subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName,  subnetName)
           }
        }
      }
    ]
  }
}
