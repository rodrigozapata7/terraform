/*provider "azurerm" {
  subscription_id = "ff0f8fed-9a2a-4d9f-9e69-5aa7a6bffbfc"
  client_id = "e875adbe-1067-4ba7-bebb-097a58c45aac"
  client_secret = "3bd5d523-8b48-40b0-b026-ad02d571d26c"
  tenant_id = "f1d12032-469f-46c9-9726-609a5672deac"
  features {}
}*/

/*
resource "azurerm_resource_group" "diplomado" {
  name      = "diplomadomlvm"
  location  = "eastus2"
  tags = {
      diplomado = "dplmd"
  }
}*/

/*
resource "azurerm_resource_group" "resource-group" {
  name      = var.name
  location  = var.location
  tags = {
    diplomado = "dplmd"
  }
}*/

/*variable "name" {

}

variable "location" {

}*/

/*
// virtual_network

resource "azurerm_virtual_network" "virtualnetwork" {
  name = "example-network"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

// subnet
resource "azurerm_subnet" "subnet" {
  name = "internal"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes = [ "10.0.2.0/24" ]
}

// public ip 

resource "azurerm_public_ip" "publicip" {
  name = "public-ip"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location = azurerm_resource_group.resourcegroup.location
  allocation_method = "Static"

  tags = {
    diplomado = var.grupo
  }
}
*/



resource "azurerm_resource_group" "resourcegroup" {
name      = var.name
  location  = var.location
  tags = {
    diplomado = "dplmd"
  }
}

/*
resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "network-rodz112"
  address_space       = [ "12.0.0.0/16" ]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet" {
  name                  = "internal"
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  virtual_network_name  = azurerm_virtual_network.virtualnetwork.name
  address_prefixes      = [ "12.0.0.0/20" ]
}

resource "azurerm_container_registry" "acr" {
  name                = "containerRegistryRodz112"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  sku                 = "Basic"
  admin_enabled       = true        
}
*/

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "network-rodz112"
  address_space       = [ "12.0.0.0/16" ]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet" {
  name                  = "internal"
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  virtual_network_name  = azurerm_virtual_network.virtualnetwork.name
  address_prefixes      = [ "12.0.0.0/20" ]
}

resource "azurerm_kubernetes_cluster" "kubernetescluster" {
  name                = "aksdiplomado"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  dns_prefix          = "aks1"
  kubernetes_version  =  "1.22.4"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "standard_D2as_v2"
    vnet_subnet_id      = azurerm_subnet.subnet.id
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
    node_labels         = {
        "node_pool" = "Adicional"
      }
  }

  service_principal {
    client_id = "e875adbe-1067-4ba7-bebb-097a58c45aac"
    client_secret = "3bd5d523-8b48-40b0-b026-ad02d571d26c"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  role_based_access_control_enabled = true
}

resource "azurerm_kubernetes_cluster_node_pool" "azureclusternodepool" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetescluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  max_pods              = 100

  tags = {
    Environment = "Test"
  }
}
