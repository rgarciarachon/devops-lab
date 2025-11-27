# Se crean los outputs en el módulo

output "vnet_name" {
    value = azurerm_virtual_network.example.name
}

output "vnet_id" {
    value = azurerm_virtual_network.example.id
}

output "vnet_location" {
    value = azurerm_virtual_network.example.location
}

output "existent_resource_group_name" {
    value = azurerm_virtual_network.example.resource_group_name
}

output "vnet_address_space" {
    value = azurerm_virtual_network.example.address_space
}

output "vnet_tags" {
    value = azurerm_virtual_network.example.tags
}