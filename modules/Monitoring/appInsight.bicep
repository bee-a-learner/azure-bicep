
param resource_Name string= ''

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

resource appinsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: resource_Name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }

  tags: tags
}
