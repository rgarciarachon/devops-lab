# Definición de variables de entrada

variable "vnet_address_space" {
    description = "Espacio de direcciones IP que tendrá la vnet."
    type = list(string)
}

variable "existent_resource_group_name" {
    description = "Nombre del Resource Group existente donde se desplegará la vnet."
    type = string
}

variable "vnet_location" {
    description = "Región de Azure donde se desplegará la vnet."
    type = string
    default = "West Europe"
}

variable "vnet_name" {
    description = "Nombre de la vnet."
    type = string
}

variable "owner_tag" {
    description = "Describe el propietario de la vnet."
    type = string
}

variable "environment_tag" {
    description = "Describe el entorno de la vnet."
    type = string
}

variable "vnet_tags" {
    description = "Describe los tags adicionales que se aplicarán a la vnet."
    type = map(string)
    default = {} # Valor vacío por defecto
}