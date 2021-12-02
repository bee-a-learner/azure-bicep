@maxLength(24)
@minLength(3)
@description('name of the keyvault resource')
param keyvault_name string= '${uniqueString(resourceGroup().id)}-kv' 

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
  'standard'
  'premium'
  ])
  @description('key vault resource kind')
  param sku string = 'standard'

param enablePurgeProtection bool = true
param enabledForDeployment bool = true
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true
param enableRbacAuthorization bool = false
param softDeleteRetentionInDays int = 90


@description('Configuration to restrict storae access from select network or IPs only')
param networkAcls object = {
  defaultAction: 'Deny'
  bypass: 'AzureServices'
  ipRules: []
  resourceAccessRules: []
  virtualNetworkRules: []
}

var createMode  = 'default'

param accessPolicies array = [
  {
    tenantId: tenant().tenantId
    objectId: 'caeebed6-cfa8-45ff-9d8a-03dba4ef9a7d' // replace with your objectId
    permissions: {
      keys: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      secrets: [
        'Get'
        'List'
        'Set'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      certificates: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'ManageContacts'
        'ManageIssuers'
        'GetIssuers'
        'ListIssuers'
        'SetIssuers'
        'DeleteIssuers'
      ]
    }
  }
]


@description('resource tags')
param tags object = {}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyvault_name
  location: location

  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    tenantId: tenant().tenantId
    enablePurgeProtection: enablePurgeProtection
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays

    networkAcls: networkAcls
    createMode: createMode
    enableRbacAuthorization: enableRbacAuthorization
    sku: {
      family: 'A'
      name: sku
    }
    accessPolicies: accessPolicies
  }

  tags: tags 
}

output keyVault_id string = keyVault.id 


