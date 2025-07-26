resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: 'vnet'
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.13.37.0/24'
      ]
    }
    subnets: [
      {
        name: 'labsubnet'
        properties: {
          addressPrefix: '10.13.37.0/24'
        }
        }
      ]
      }
    }

resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
name: 'labvmnic'
location: 'eastus' 
properties: {
ipConfigurations: [
{
  name : 'ipconfig1'
  properties: {
    subnet: {
      id: vnet.properties.subnets[0].id
    }
  }
}
]
}
}


resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: 'labvm'
  location: 'eastus'
  properties:  {
     hardwareProfile: {
       vmSize: 'Standard_D8s_v3'
     }
      osProfile: {
        computerName: 'labvm'
         adminUsername: 'azureuser'
          adminPassword: 'LongAndStrongPassword123!'
                }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2022-Datacenter'
          version: 'latest'
        }
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: nic.id
                      }
        ]
      }
  }
  }
