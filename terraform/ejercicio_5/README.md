# Terraform
## Ejercicio 5

>[!WARNING]
    Es necesario haber completado el ejercicio 4 para poder realizar este ejercicio.

En este ejercicio, se debe utilizar el contenido desarrollado en los ejercicios anteriores para crear un módulo de Terraform siguiendo la estructura recomendada por HashiCorp. El nuevo módulo hará uso del módulo previamente creado, que se encuentra ubicado de manera local, e incluirá los siguientes archivos:

- ``main.tf``: define los recursos.

- ``variables.tf``: define las variables de entrada.

- ``outputs.tf``: define los valores de salida.

- ``terraform.tfvars``: asigna los valores a las variables de entrada.

### Creación del nuevo módulo

La estructura de carpetas recomendada por HashiCorp para organizar los módulos de Terraform está diseñada para ser clara, modular y reutilizable. La estructura utilizada consta de los siguientes archivos y carpetas:

````bash
$ tree ficheros/ # Archivos principales
.
├── README.md
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── modules/
│   ├── az_vnet/ # Módulo az_vnet
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── main.tf
│   │   ├── outputs.tf
````

El módulo debe ubicarse en la carpeta ``modules/``, dentro de su propia subcarpeta, siguiendo la estructura de archivos correspondiente.

### Configuración de archivos
#### PASO 1: definición de recursos en ``main.tf``

Una vez creado el módulo y definida su estructura, se modifica el archivo ``main.tf`` para sustituir la definición directa de recursos por una invocación al módulo local. Este cambio contribuye a mantener un código más limpio, modular y organizado.

````terraform
module "module_name" {
  source = "./path"
}
````

La instrucción ``source`` indica la ubicación del módulo. Cuando se utiliza una ruta local, debe comenzar con ./ o ../, lo que permite distinguirla de una fuente remota como el **Terraform Registry**, donde se alojan módulos compartidos públicamente.

````terraform
# main.tf de la raíz

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
````

Según las buenas prácticas recomendadas por Terraform, la configuración del proveedor debe definirse en el proyecto que consume o invoca el módulo, y no dentro del propio módulo. Esto permite una mayor flexibilidad, evita duplicaciones y facilita la reutilización del módulo en distintos entornos.

Por ello, se modifica el archivo ``main.tf`` del módulo para que no incluya dicha configuración:

````terraform
# main.tf del módulo az_vnet

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

<br>

#### PASO 2: definición de salidas en ``output.tf``

En este paso, se definen las salidas del módulo, las cuales permiten exponer información útil sobre los recursos creados.

Terraform muestra automáticamente estos valores al ejecutar comandos como ``terraform apply`` o ``terraform output``, lo que evita tener que comprobarlo manualmente. No obstante, para que estos datos se visualicen correctamente desde el proyecto principal, es imprescindible definir un archivo ``outputs.tf`` tanto en el módulo como en la raíz del proyecto.

<br>

En primer lugar, se definen las salidas del módulo:

````terraform
# Outputs del módulo

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
````

**Aspectos importantes**:

- Si se quiere acceder a los valores desde dentro del módulo, se debe hacer referencia directamente a los recursos creados.


<br>

````terraform
# output.tf de la raíz

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
````

**Aspectos importantes**:

- Si se quiere acceder a los valores desde fuera del módulo, se debe utilizar la palabra clave ``module`` seguida del nombre del módulo y el nombre de la salida deseada.

<br>

#### PASO 3: archivos ``terraform.tfvars`` y ``variables.tf``

Estos archivos permanecen igual que en el ejercicio anterior. No hay cambios necesarios en ellos.

### Comprobación

Para comprobar que el código se ha creado correctamente, se ejecuta el comando ``terraform init`` para inicializar el entorno de Terraform:

````powershell
terraform init
````

![terraform init](/terraform/datos/ejercicio%205/ejercicio-5_1.1.png)

Posteriormente, se ejecutan los comandos ``terraform plan`` y ``terraform apply`` para crear los recursos de Azure:

````powershell
terraform plan
````

![terraform plan](/terraform/datos/ejercicio%205/ejercicio-5_1.2.png)


````powershell
terraform apply
````

En la salida de la consola, es posible verificar los valores definidos en el archivo ``outputs.tf``, lo que permite confirmar que las salidas se han configurado correctamente.

![terraform apply](/terraform/datos/ejercicio%205/ejercicio-5_1.3.png)

![outputs](/terraform/datos/ejercicio%205/ejercicio-5_1.4.png)

Como se puede observar, los recursos solicitados se han creado correctamente en Azure y presentan los valores definidos en los archivos de configuración.

![recurso](/terraform/datos/ejercicio%205/ejercicio-5_1.5.png)
