terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "4.27.0"
        }
    }
    required_version = ">= 1.1.0"
}

# Configuración del proveedor de Azure
provider "azurerm" {
    features {} # Activa las funciones del proveedor
}

# Llamada al módulo local
module "az_vnet" {
    source = "./modules/az_vnet"

    vnet_name                = var.vnet_name
    vnet_location            = var.vnet_location
    existent_resource_group_name = var.existent_resource_group_name
    vnet_address_space       = var.vnet_address_space

    owner_tag                = var.owner_tag
    environment_tag          = var.environment_tag
    vnet_tags                = var.vnet_tags
}