
// @maxLength(24)
// @minLength(3)
// @description('name of the keyvault resource')
// param keyvault_name string= ''

// resource  kv_access_policy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
//   name: 
//   properties: {
//     accessPolicies: 
//   }
// }


// resource kv_access_policy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
//   name: 'string'
//   parent: keyvault_name
//   properties: {
//     accessPolicies: [
//       {
//         applicationId: 'string'
//         objectId: 'string'
//         permissions: {
//           certificates: [ 'string' ]
//           keys: [ 'string' ]
//           secrets: [ 'string' ]
//           storage: [ 'string' ]
//         }
//         tenantId: 'string'
//       }
//     ]
//   }
// }
