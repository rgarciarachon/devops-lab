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

# Recursos para la vnet
# Las variables se toman del archivo terraform.tfvars
resource "azurerm_virtual_network" "example" {
    name                = var.vnet_name
    location            = var.vnet_location
    resource_group_name = var.existent_resource_group_name
    address_space       = var.vnet_address_space
}