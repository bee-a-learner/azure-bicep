param sqlServerName string =  '${uniqueString(resourceGroup().id)}-sql'
param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

@allowed([
  'Enabled'
  'Disabled'
])
param transparentDataEncryption string = 'Enabled'

param location string = resourceGroup().location

var databaseName = 'sample-db-with-tde'
var databaseEdition = 'Basic'
var databaseCollation = 'SQL_Latin1_General_CP1_CI_AS'
var databaseServiceObjectiveName = 'Basic'


@description('resource tags')
param tags object = {}

resource sqlServer 'Microsoft.Sql/servers@2020-02-02-preview' = {
  name: sqlServerName
  location: location
  properties: {
    minimalTlsVersion: '1.2' 
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
  }

  identity: {
    type: 'SystemAssigned'

  }
  tags: tags
}

resource db 'Microsoft.Sql/servers/databases@2020-02-02-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  sku: {
    name: databaseServiceObjectiveName
    tier: databaseEdition
  }
  properties: {
    collation: databaseCollation

  }
}

// very long type...
resource tde 'Microsoft.Sql/servers/databases/transparentDataEncryption@2020-08-01-preview' = {
  parent: db
  name: 'current'
  properties: {
    state: transparentDataEncryption
  }
}




resource sqlserverName_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2014-04-01' = {
  name: '${sqlServer.name}/AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}


output sql_server_id string = sqlServer.id 

output sql_server_db_id string = db.id
