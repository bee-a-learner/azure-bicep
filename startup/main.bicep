
module fullname_module 'sample.bicep'= {
  name: 'm1'
  params: {
    first_name: 'John'
    last_name: 'smith'
  }
}

output myname string = fullname_module.outputs.full_name

resource rg1 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'demo-rg'
  scope: subscription()
}

module st1 '../modules/Storage/storage_account/storage_account.bicep' = {
  name: 'st_one'
  scope: rg1
}

resource rg2 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'demo-rg2'
  scope: subscription()
}

module st2 '../modules/Storage/storage_account/storage_account.bicep' = {
  name: 'st_two'
  scope: rg2
}
