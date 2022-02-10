targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

@description('ResourceGroup input parameter')
param resourceGroupParameters object

@description('Network Security Group input parameter')
param networkSecurityGroupParameters object

@description('Virtual Network input parameter')
param vNetParameters object

@description('Log analytics input parameter')
param lawParameters object

// Shared
param location string = deployment().location

// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'br/modules:microsoft.resources.resourcegroups:0.4.735' = if (resourceGroupParameters.enabled) {
  name: '${uniqueString(deployment().name, location)}-rg'
  scope: subscription()
  params: {
    name: resourceGroupParameters.name
    location: location
  }
}

// Log Analytics Workspace
module law 'br/modules:microsoft.operationalinsights.workspaces:0.4.735' = if(lawParameters.enabled) {
  name: '${uniqueString(deployment().name, location)}-law'
  scope: resourceGroup(resourceGroupParameters.name)
  params: {
    name: lawParameters.name

  }
  dependsOn: [
    rg
  ]
}

// Network Security Group
module nsg 'br/modules:microsoft.network.networksecuritygroups:0.4.735' = if (networkSecurityGroupParameters.enabled) {
  name: '${uniqueString(deployment().name, location)}-nsg'
  scope: resourceGroup(resourceGroupParameters.name)
  params: {
    name: networkSecurityGroupParameters.name
    diagnosticWorkspaceId: law.outputs.resourceId
  }
  dependsOn: [
    rg
  ]
}

// Virtual Network
module vnet 'br/modules:microsoft.network.virtualnetworks:0.4.735' = if (vNetParameters.enabled) {
  name: '${uniqueString(deployment().name, location)}-vnet'
  scope: resourceGroup(resourceGroupParameters.name)
  params: {
    subnets: vNetParameters.subnets
    addressPrefixes: vNetParameters.addressPrefixes
    name: vNetParameters.name
    diagnosticWorkspaceId: law.outputs.resourceId                 
  }
  dependsOn: [
    rg
    nsg
  ]
}
