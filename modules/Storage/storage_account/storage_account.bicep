@maxLength(24)
@minLength(3)
@description('name of the storage account resource')
param storage_account_name string= 'st${uniqueString(resourceGroup().name)}'

@allowed([
  'Central US'           
  'East US'  
  'East US 2'
  'West US' 
  'North Central US'    
  'South Central US'    
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
'StorageV2'
'Storage'
'BlobStorage'
'FileStorage'
'BlockBlobStorage'
])
@description('storage account resource kind')
param kind string = 'StorageV2'


@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
  ])
  @description('storage account resource kind')
  param sku string = 'Standard_LRS'

  @description('storage account resource tags')
  param tags object = {}

  @description('true if storage account needs public access (not recommended), otherwise false')
  param allowBlobPublicAccess bool = false

  @description('true if storage account allow only https traffic (recommended), otherwise false')
  param supportsHttpsTrafficOnly bool = true
  
  @description('Configuration to restrict storae access from select network or IPs only')
  param networkAcls object = {
    defaultAction: 'Deny'
    bypass: 'AzureServices'
    ipRules: []
    resourceAccessRules: []
    virtualNetworkRules: []
  }

  param storage_containers array = []
  param storage_fileshares array = []
  param storage_queues array = []

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storage_account_name
  location: location
  kind: kind
  sku: {
    name: sku
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    networkAcls: networkAcls
  }

  identity: {
    type: 'SystemAssigned'
  }

  tags: tags
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for cnt in storage_containers: {
  name: '${storageaccount.name}/default/${cnt}'
}]


resource fileShares 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01' = [for file in storage_fileshares: {
  name: '${storageaccount.name}/default/${file}'
}]

resource queues 'Microsoft.Storage/storageAccounts/queueServices/queues@2021-06-01' = [for queue in storage_queues: {
  name: '${storageaccount.name}/default/${queue}'
}]


output storage_account_id string = storageaccount.id

output storage_account_identity string = storageaccount.identity.principalId


