provider "azurerm" {
    features {}
}

# Se añade un recurso para hacer un plan mínimo y validar la autenticación
resource "azurerm_resource_group" "example" {
    name     = "example-resources"
    location = "East US"
}
