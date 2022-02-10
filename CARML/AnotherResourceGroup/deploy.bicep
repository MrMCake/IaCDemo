targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

@description('ResourceGroup input parameter')
param rgParam object

@description('Log analytics input parameter')
param lawParam object

@description('Network Security Group input parameter')
param nsgParam object

@description('Virtual Network input parameter')
param vNetParam object

// Shared
param location string = deployment().location

// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'br/modules:microsoft.resources.resourcegroups:0.4.735' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  scope: subscription()
  params: {
    name: rgParam.name
    location: location
    roleAssignments: rgParam.name
  }
}

// Log Analytics Workspace
module law 'br/modules:microsoft.operationalinsights.workspaces:0.4.735' = {
  name: '${uniqueString(deployment().name, location)}-law'
  scope: resourceGroup(rgParam.name)
  params: {
    name: lawParam.name
  }
  dependsOn: [
    rg
  ]
}

// Network Security Group
module nsg 'br/modules:microsoft.network.networksecuritygroups:0.4.735' = {
  name: '${uniqueString(deployment().name, location)}-nsg'
  scope: resourceGroup(rgParam.name)
  params: {
    name: nsgParam.name
  }
  dependsOn: [
    rg
  ]
}

// Virtual Network
module vnet 'br/modules:microsoft.network.virtualnetworks:0.4.735' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  scope: resourceGroup(rgParam.name)
  params: {
    subnets: vNetParam.subnets
    addressPrefixes: vNetParam.addressPrefixes
    name: vNetParam.name
  }
  dependsOn: [
    rg
    nsg
  ]
}
