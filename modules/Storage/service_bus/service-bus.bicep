param serviceBusNamespaceName string
param serviceBusQueueName string


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

@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param sku string = 'Standard'


param subnet_name string  = ''
param vnetName string = ''


resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: sku
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  name: '${serviceBusNamespace.name}/${serviceBusQueueName}'
  properties: {
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    deadLetteringOnMessageExpiration: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}


// Integrated service bus to vnet

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01'  existing = if(vnetName != '' && subnet_name != '' ) {
  name: '${vnetName}/${subnet_name}'
}

resource namespaceVirtualNetworkRule 'Microsoft.ServiceBus/namespaces/VirtualNetworkRules@2018-01-01-preview' = if(vnetName != '' && subnet_name != '' ) {
  name: '${serviceBusNamespace.name}/${vnetName}'
  properties: {
    virtualNetworkSubnetId: subnet.id
  }
}
