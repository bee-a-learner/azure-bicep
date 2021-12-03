
param resource_Name string= '${uniqueString(resourceGroup().id)}-apim' 

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


@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'
param publisherEmail string  = 'publisherEmail@contoso.com'
param publisherName string = 'publisherName'

param subnet_name string  = ''
param vnetName string = ''


resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01'  existing = if(virtualNetworkType != 'None') {
  name: '${vnetName}/${subnet_name}'
}


resource apiManagementInstance 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: resource_Name
  location: location
  tags: tags
  sku:{
    capacity: 0
    name: 'Developer'
  }

  identity: {
    type: 'SystemAssigned'
  }
  
  properties:{
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: {
      subnetResourceId: (subnet_name == '' && virtualNetworkType != 'None')  ? subnet.id : ''
    }
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

//publish api to apim management
//https://github.com/Azure/bicep/blob/main/docs/examples/301/publish-api-to-apim-opendocs/main.bicep



// resource apiManagementLogger 'Microsoft.ApiManagement/service/loggers@2019-01-01' = {
//   name: appInsightsName
//   parent: apiManagement
//   properties: {
//     loggerType: 'applicationInsights'
//     description: 'Logger resources to APIM'
//     credentials: {
//       instrumentationKey: applicationInsights.properties.InstrumentationKey
//     }
//   }
// }

// resource apimInstanceDiagnostics 'Microsoft.ApiManagement/service/diagnostics@2020-06-01-preview' = {
//   name: 'applicationinsights'
//   parent: apiManagement
//   properties: {
//     loggerId: apiManagementLogger.id
//     alwaysLog: 'allErrors'
//     logClientIp: true
//     sampling: {
//       percentage: 100
//       samplingType: 'fixed'
//     }
//   }
// }
