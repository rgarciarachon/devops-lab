# Se crean los outputs en raíz

output "vnet_name" {
    value = module.az_vnet.vnet_name
}

output "vnet_id" {
    value = module.az_vnet.vnet_id
}

output "vnet_location" {
    value = module.az_vnet.vnet_location
}

output "existent_resource_group_name" {
    value = module.az_vnet.existent_resource_group_name
}

output "vnet_address_space" {
    value = module.az_vnet.vnet_address_space
}

output "vnet_tags" {
    value = module.az_vnet.vnet_tags
}