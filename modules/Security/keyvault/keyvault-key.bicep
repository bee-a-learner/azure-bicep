

param keyvault_name string= ''
param key_name string= ''


// create key
resource key 'Microsoft.KeyVault/vaults/keys@2019-09-01' = {
  name: '${keyvault_name}/${key_name}'
  properties: {
    kty: 'RSA' // key type
    keyOps: [
      // key operations
      'encrypt'
      'decrypt'
    ]
    keySize: 4096
  }
}


output keyId string = key.id
