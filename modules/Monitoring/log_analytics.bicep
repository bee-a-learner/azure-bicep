
@maxLength(24)
@minLength(3)
@description('name of the keyvault resource')
param resource_name string= '${uniqueString(resourceGroup().id)}-log' 

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


@allowed([
  'PerGB2018'
  'Free'
  'Standard'
  'Premium'
  ])
  @description('key vault resource kind')
  param sku string = 'PerGB2018'

  
@description('resource tags')
param tags object = {}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: resource_name
  location: location
  properties: {
    sku: {
      name: sku
    }
  }

  tags: tags
}

param workspace_solutions array = [
  {
    name: 'KeyVaultAnalytics(axso-prod-core-loga)'
    product: 'OMSGallery/KeyVaultAnalytics'
    publisher: 'Microsoft'
  }
]
resource logAnalyticsSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for item in workspace_solutions: {
    name: item.resource_name
    location: location
    properties: {
      workspaceResourceId: logAnalyticsWorkspace.id
      // containedResources: [
      //   'view.id'
      // ]
    }
    plan: {
      name: item.resource_name
      product: item.product
      publisher: item.publisher
    }
}]


