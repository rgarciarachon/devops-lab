# Terraform
## Ejercicio 3

En este ejercicio, se debe modificar el módulo creado anteriormente para incluir tres nuevas variables:

- ``owner_tag``:

    - Tipo: string
    - Obligatoria
    - Descripción: Define el propietario de la VNet.

- ``environment_tag``:

    - Tipo: string
    - Obligatoria
    - Descripción: Define el entorno de la VNet (por ejemplo, dev, test, prod).

- ``vnet_tags``:

    - Tipo: map(string)
    - Opcional, con un valor por defecto de un mapa vacío.
    - Descripción: Define los tags adicionales que se aplicarán a la VNet.

Requisitos:

El módulo debe estar diseñado para combinar estos tres tipos de *tags*, los obligatorios y los opcionales. En el caso de que se defina un *tag* con el mismo nombre que ``owner`` o ``environment``, el valor se sobrescribirá por el que se haya especificado en ``vnet_tags``.

### Configuración de los archivos

#### PASO 1: definición de recursos en ``main.tf``

Se modifica el archivo anterior y se incluyen dos nuevas variables: ``owner_tag`` y ``environment_tag``, que permiten definir el propietario y el entorno de la VNet. 

Además, se introduce el bloque ``locals``, que define valores temporales que pueden ser utilizados en otras partes del módulo. En este caso, dicho bloque permite combinar los *tags* obligatorios con los opcionales.

El resultado de esta combinación se guarda en la variable ``merged_tags``, que posteriormente se emplea para establecer los tags del recurso ``azurerm_virtual_network``.


````terraform
# main

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

# Bloque que permite definir valores temporales
locals {
    default_tags = {
        owner       = var.owner_tag
        environment = var.environment_tag
    }

    # Función que une los tags
    merged_tags = merge(local.default_tags, var.vnet_tags)
}

# Recursos para la vnet
# Las variables se toman del archivo terraform.tfvars
resource "azurerm_virtual_network" "example" {
    name                = var.vnet_name
    location            = var.vnet_location
    resource_group_name = var.existent_resource_group_name
    address_space       = var.vnet_address_space

    tags = local.merged_tags
}
````

**Aspectos importantes**:

- Gracias a la función ``merge()``, se consigue sobrescribir el valor de ``owner`` y ``environment`` en caso de que dichas claves estén también definidas en ``vnet_tags``, lo que garantiza que los valores proporcionados por esta última variable tengan prioridad.

<br>

#### PASO 2: definición de variables en ``variables.tf``

En este archivo, se añaden las tres nuevas variables, ``owner_tag``, ``environment_tag`` y ``vnet_tags``, a las ya existentes.

````terraform
# variables.tf

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
````
<br>

#### PASO 3: asignación de valores a las variables en ``terraform.tfvars``

En este archivo, se asignan los valores a las nuevas variables declaradas en ``variables.tf``.

````terraform
# terraform.tfvars

existent_resource_group_name    = "rg-rgarcia-dvfinlab"
vnet_name                       = "vnetrgarciatfexercise01"
vnet_address_space              = ["10.0.0.0/16"]

owner_tag                       = "Unknown"
environment_tag                 = "dev"

vnet_tags = {
    "owner" = "Raquel"
}
````

**Aspectos importantes**:

- En ``vnet_tags`` se redefine el valor del *tag* ``owner``, lo que provocará que este sobrescriba al valor inicial gracias a la función ``merge()``.

### Comprobación

Para comprobar que el código se ha creado correctamente, se ejecuta el comando ``terraform init`` para inicializar el entorno de Terraform:

````powershell
terraform init
````

![terraform init](/terraform/datos/ejercicio%203/ejercicio-3_1.1.png)

Posteriormente, se ejecutan los comandos ``terraform plan`` y ``terraform apply`` para crear los recursos de Azure:

````powershell
terraform plan
````

![terraform plan](/terraform/datos/ejercicio%203/ejercicio-3_1.2.png)

````powershell
terraform apply
````

![terraform apply](/terraform/datos/ejercicio%203/ejercicio-3_1.3.png)

Como se puede observar, los recursos solicitados se han creado correctamente en Azure y presentan los valores definidos en los archivos de configuración.

![terraform apply](/terraform/datos/ejercicio%203/ejercicio-3_1.4.png)

Para finalizar, se destruye el entorno de Azure mediante el comando ``terraform destroy``.

````powershell
terraform destroy
````