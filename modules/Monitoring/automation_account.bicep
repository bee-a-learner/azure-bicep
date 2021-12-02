

@maxLength(24)
@minLength(3)
@description('name of the keyvault resource')
param resource_name string= '${uniqueString(resourceGroup().id)}-aa' 

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
  'Basic'
  'Free'
  ])
  @description('key vault resource kind')
  param sku string = 'Free'

  @description('resource tags')
  param tags object = {}
  
resource automationAccount 'Microsoft.Automation/automationAccounts@2019-06-01' = {
  name: resource_name
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
  }
}
