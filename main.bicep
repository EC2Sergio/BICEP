// Parameters
@description('Username for the Virtual Machine administrator')
param adminUsername string = 'azureuser'

@description('Password for the Virtual Machine administrator')
@secure()
param adminPassword string

@description('Location for all resources')
param location string = 'eastus'

@description('Size of the Virtual Machine')
param vmSize string = 'Standard_D8s_v3'

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: 'vnet'
  location: location
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

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: 'labvmnic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}


// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: 'labvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'labvm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
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
