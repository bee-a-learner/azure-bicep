// @description('The basename of the storage account to create.')
// param basename string =''

  @description('A list of prefix to append as the first characters of the generated name - prefixes will be separated by the separator character.')
  param prefix string = 'company-project' 


 @description('A list of additional suffix added after the basename, this is can be used to append resource index (eg. str001). Suffixes are separated by the separator character.')
 param suffix string = 'location-env-instance'

// @description('If a slug should be added to the name - If you put false no slug (the few letters that identify the resource type) will be added to the name.')
// param use_slug bool = true


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


 @description('The separator character to use between prefixes, resource type, base name, suffixes, randon character.')
 param separator string = '-'

var random_first_letter   = substring(uniqueString('abcdefghijklmnopqrstuvwxyz'),1) 

var random              = guid(subscription().subscriptionId) 

output result string = random_first_letter
output result_random string = random
output result_name string = '${prefix}${separator}${suffix}'
output result_location string = location

