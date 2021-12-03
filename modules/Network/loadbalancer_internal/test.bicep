

param pip object = {
   pipulluhqqfddh4o : { 
     name : 'pip-ulluhqqfddh4o'
   }
}
resource publict 'Microsoft.Network/publicIPAddresses@2021-03-01' existing = [for item in items(pip): {
  name: item.value.name
}]

output result object = publict[0]
