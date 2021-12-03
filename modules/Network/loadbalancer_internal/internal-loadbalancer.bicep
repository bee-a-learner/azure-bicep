@description('name of the resource group')
param resource_name string = 'lb-${uniqueString(resourceGroup().name)}'

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
param location string = 'East US'

@description('resource tags')
param tags object = {}


@allowed([
  'Basic'  
  'Standard'
  'Gateway'
])
param sku_name string = 'Standard'

@allowed([
  'Regional'  
  'Global'
])
param sku_tier string = 'Regional'



param probes object = {
  probe1 :{
    port: 8080
    protocol: 'Tcp'
    requestPath: '/'
    intervalInSeconds: 5
    numberOfProbes: 2
  }
}

param backendAddressPools object = {
 pool1 : {
    virtualNetworkName : 'networking-vnet'
    subnetName : 'data-subnet'
 }
}


param frontend_public_ip_name string ='pip-ulluhqqfddh4o'

resource pip 'Microsoft.Network/publicIPAddresses@2021-03-01' existing = if(!empty(frontend_public_ip_name)){
  name: frontend_public_ip_name
}

output pipid string =  pip.id

param frontendIPConfigurationName string = 'frontend'
param lb_rules object = {
  rule1 :{
    frontendPort: 8080
    protocol: 'Tcp'
    backendPoolName : 'pool1'
    frontend_public_ip_name : frontendIPConfigurationName
    backendPort: 8080
    probeName: 'probe1'
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-03-01' = {
  name: resource_name
  location: location
  tags: tags
  sku:{
    name: sku_name
    tier: sku_tier
  }
  properties: {
    //backendAddressPools: backendAddressPools
    frontendIPConfigurations: [
      {
        name: frontendIPConfigurationName

        properties: {
          publicIPAddress: {
            id: empty(frontend_public_ip_name) ? null : pip.id
          }
          // subnet: {
          //   id: resourceId('Microsoft.Network/virtualNetworks/subnets', pool.value.virtualNetworkName,  pool.value.subnetName)
          // }  
        }
      }
    ]

    backendAddressPools: [for pool in items(backendAddressPools) : {
      name: pool.key
      properties: {
        loadBalancerBackendAddresses: [
          {
            name: pool.key
            properties: {
              subnet: {
                id: resourceId('Microsoft.Network/virtualNetworks/subnets', pool.value.virtualNetworkName,  pool.value.subnetName)
              }
              virtualNetwork: {
                id: resourceId('Microsoft.Network/virtualNetworks', pool.value.virtualNetworkName)
              }
            }
          }
        ]
      }
    }]

    loadBalancingRules: [for rule in items(lb_rules): {
      name: rule.key
      properties: {
        protocol: rule.value.protocol
        frontendPort: rule.value.frontendPort
        backendPort: rule.value.backendPort
        frontendIPConfiguration: {
          id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations',resource_name, frontendIPConfigurationName)
        }
        backendAddressPool: {
          id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', resource_name, rule.value.backendPoolName)
        }
        probe: {
           id:  resourceId('Microsoft.Network/loadBalancers/probes', resource_name, rule.value.probeName)
        }
      }
    }]
    probes: [for prb in items(probes): {
      name: prb.key
      properties: {
        port: prb.value.port
        protocol: prb.value.protocol
        requestPath: (prb.value.protocol == 'Tcp') ? null : prb.value.requestPath
        intervalInSeconds: prb.value.intervalInSeconds
        numberOfProbes: prb.value.numberOfProbes
      }
    }]
    
  }
}
