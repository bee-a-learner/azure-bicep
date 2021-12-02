
param keyvault_name string= ''
param secret_name string= ''

@secure()
param value string = ''

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvault_name}/${secret_name}'
  properties: {
    value: value
  }
}

output secretId string = keyVaultSecret.id
