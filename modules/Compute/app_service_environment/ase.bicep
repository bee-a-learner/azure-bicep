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

resource ase 'Microsoft.Web/hostingEnvironments@2021-02-01' = {
  name: resource_name
  location: location
  tags: tags
  //kind:
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', virtualNetworkName)
      subnet:  subnetName
    }
  } 
}
