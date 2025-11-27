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

    validation {
        # Asegura que el vnet_name cumpla con el patrón requerido
        condition     = startswith(var.vnet_name, "vnet")
        error_message = "El valor de vnet_name debe comenzar con el prefijo 'vnet'."
    }
}

variable "owner_tag" {
    description = "Describe el propietario de la vnet."
    type = string

    validation {
        # Asegura que el owner_tag no sea una cadena vacía
        condition     = length(var.owner_tag) > 0
        error_message = "El owner_tag no puede ser una cadena vacía."
    }
}

variable "environment_tag" {
    description = "Describe el entorno de la vnet."
    type = string

    validation {
        # Asegura que el environment_tag no sea una cadena vacía y contenga uno de los valores permitidos
        condition     = length(var.environment_tag) > 0 && contains(["dev", "pro", "tes", "pre"], lower(var.environment_tag))
        error_message = "El environment_tag no puede ser una cadena vacía y debe contener uno de los siguientes valores: DEV, PRO, TES o PRE."
    }
}

variable "vnet_tags" {
    description = "Describe los tags adicionales que se aplicarán a la vnet."
    type = map(string)
    default = {} # Valor vacío por defecto

    validation {
        # Asegura que el vnet_tags no sea un mapa vacío
        # Asegura que ninguno de los valores del mapa sea una cadena vacía
        condition     = length(keys(var.vnet_tags)) > 0 && alltrue([for v in var.vnet_tags : v != "" && v != null])
        error_message = "La variable vnet_tags no puede contener valores nulos ni cadenas vacías."
    }
}