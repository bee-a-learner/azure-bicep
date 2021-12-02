@description('name of the resource')
param resource_name string= '${uniqueString(resourceGroup().id)}-web' 

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

  param app_service_plan string
  

@allowed([
  'linux'
  'windows'
  'functionapp'
])
param application_kind string = 'windows'

@description('resource tags')
param tags object = {}


param subnet_name string =''
param vnet_name string =''


param connectionStrings array = [
  // {
  //   connectionString: ''
  //   name: ''
  //   type: 'SQLServer'
  // }
]

param appSettings array =  []

param appInsightsName string = ''

@maxLength(24)
@minLength(3)
param storageAccountName string = ''


param javaContainer string = ''
param javaContainerVersion string = ''
param javaVersion string = ''
param netFrameworkVersion string = ''
param phpVersion string = ''
param vnetName string = ''
param nodeVersion string = ''

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if(storageAccountName != '') {
  name: storageAccountName
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = if(appInsightsName != '') {
  name: appInsightsName
}

var storageAccountConnectionString = (storageAccountName != '') ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}':''

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: app_service_plan
}

resource web_app 'Microsoft.Web/sites@2018-11-01'  = {
  name: resource_name
  location: location
  kind: application_kind
  identity: {
    type: 'SystemAssigned'
  }

  tags: tags

  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled:  false
    httpsOnly: true 
    
    siteConfig: {
      defaultDocuments: [
        'Default.htm'
        'Default.html'
        'Default.asp'
        'index.htm'
        'index.html'
        'iisstart.htm'
        'default.aspx'
        'index.php'
        'hostingstart.html'
      ]
      alwaysOn: true 
      javaContainer: javaContainer
      javaContainerVersion: javaContainerVersion
      javaVersion: javaVersion
      minTlsVersion: '1.2'
      netFrameworkVersion: netFrameworkVersion
      phpVersion: phpVersion
      pythonVersion: ''
      vnetName: vnetName
      nodeVersion: nodeVersion

      //ipSecurityRestrictions: ipSecurityRestrictions

      //connection strings
      connectionStrings: connectionStrings

      //key vaule pair connection strings
      appSettings: concat(appSettings,[
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountConnectionString
        }
      ])
    }
  }
  
}


resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' existing = if(subnet_name != '')  {
  name: '${vnet_name}/${subnet_name}'
}

resource webappVnet 'Microsoft.Web/sites/networkConfig@2020-06-01' = if(subnet_name != '') {
  parent: web_app
  name: 'virtualNetwork'
  properties: {
    subnetResourceId: subnet.id
    swiftSupported: true
  }
  dependsOn: [
    web_app  
  ]
}


// resource key2 'Microsoft.AppConfiguration/configurationStores/keyValues@2020-07-01-preview' = {
//   name: '${config.name}/${keyValueNames[1]}'
//   properties: {
//     value: keyValueValues[1]
//     contentType: contentType
//   }
// }

// // Data resources
// resource sqlserver 'Microsoft.Sql/servers@2019-06-01-preview' = {
//   name: sqlserverName
//   location: location
//   properties: {
//     administratorLogin: sqlAdministratorLogin
//     administratorLoginPassword: sqlAdministratorLoginPassword
//     version: '12.0'
//   }
// }
// resource webSiteConnectionStrings 'Microsoft.Web/sites/config@2020-06-01' = {
//   name: '${web_app.name}/connectionstrings'
//   properties: {
//     DefaultConnection: {
//       value: 'Data Source=tcp:${sqlserver.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${sqlAdministratorLogin}@${sqlserver.properties.fullyQualifiedDomainName};Password=${sqlAdministratorLoginPassword};'
//       type: 'SQLAzure'
//     }
//   }
// }



output appservice_id string = web_app.id


