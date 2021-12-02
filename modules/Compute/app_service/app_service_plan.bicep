@description('name of the resource')
param resource_name string= '${uniqueString(resourceGroup().id)}-asp' 

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
@description('region of the storage account resource')
param location string = 'UK South'

  // Web App params
  @allowed([
    'F1'
    'D1'
    'B1'
    'B2'
    'B3'
    'S1'
    'S2'
    'S3'
    'P1'
    'P2'
    'P3'
    'P4'
  ])
  param skuName string = 'F1'
  
  @minValue(1)
  param skuCapacity int = 1


@description('resource tags')
param tags object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: resource_name
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  tags: tags
}


output app_service_plan_id string = appServicePlan.id 


