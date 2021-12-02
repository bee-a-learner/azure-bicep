
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

//networkSecurityGroups

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: resource_Name
  location: location
  tags: tags
}

param nsg_rules array = [
  {

  }
]


resource nsg_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-03-01' = [for rule in nsg_rules: {
  name: rule.name
  dependsOn: [
    nsg
  ]
  properties: {
    access : rule.access =='' ? rule.access : 'Deny'
    direction: rule.direction =='' ? rule.access : 'Inbound'
    description: rule.direction =='' ? rule.direction : ''
    protocol: rule.protocol =='' ? rule.direction : 'Tcp'
   }
}]
