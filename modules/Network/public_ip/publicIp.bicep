

@description('name of the resource group')
param resource_name string = 'pip-${uniqueString(resourceGroup().name)}'
//pip-mc-nprd-ipccfgkrg-app-01


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

@allowed([
  'Basic'  
  'Standard'
])
param sku_name string = 'Standard'

@allowed([
  'Regional'  
  'Global'
])
param sku_tier string = 'Regional'

param zones array = []

resource publicip 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: resource_name
  location: location
  zones: zones
  sku: {
    name: sku_name
    tier: sku_tier
  }
  tags: tags
  properties: {
    publicIPAllocationMethod: 'Static'
    deleteOption: 'Delete'
  }
}

output public_ip_id string = publicip.id
