# Terraform
## Ejercicio 2

En este ejercicio, se deberá desarrollar un módulo de Terraform que despliegue una *Virtual Network* (VNet) en **Azure**, dentro de un *Resource Group* ya existente.

El módulo debe incluir:

- ``main.tf`` para definir el recurso (la VNet).
- ``variables.tf`` para declarar las variables necesarias.
- ``terraform.tfvars`` para definir el valor de esas variables.

Requisitos: 

- El módulo debe contener una parametrización adecuada para aceptar el siguiente contenido:

    ````terraform
    existent_resource_group_name = "<nombre_de_un_rg_ya_existente>"
    vnet_name = "vnet<tunombre>tfexercise01"
    vnet_address_space = ["10.0.0.0/16"]
    ````

- Debe existir una variable adicional, ``location``, que permita indicar la localización donde se desplegará la VNet. Si no se especifica, se debe usar ``West Europe`` por defecto.

<br>

### Creación de la estructura de archivos

Antes de comenzar con la configuración de los archivos de Terraform, se organiza y presenta la estructura del proyecto. En el directorio actual, se crea un nuevo directorio llamado ``ficheros``, que contendrá los archivos necesarios para definir y parametrizar el módulo:

````bash
ficheros/
├── main.tf
├── variables.tf
└── terraform.tfvars
````

### Configuración de los archivos

#### PASO 1: definición de recursos en ``main.tf``

Este archivo constituye el archivo principal de configuración de Terraform dentro del módulo. Su función es declarar los recursos que se desean desplegar, modificar o eliminar, junto con sus respectivas propiedades y relaciones. En este caso específico, se define una ***Virtual Network (VNet)*** en Azure, utilizando como grupo de recursos uno ya existente.

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

# Recursos para la vnet
# Las variables se toman del archivo terraform.tfvars
resource "azurerm_virtual_network" "example" {
    name                = var.vnet_name
    location            = var.vnet_location
    resource_group_name = var.existent_resource_group_name
    address_space       = var.vnet_address_space
}
````

**Aspectos importantes**:

- El recurso se configura a partir de las variables de entrada definidas en el resto de archivos del módulo, lo que permite reutilizar el mismo código en distintos entornos simplemente cambiando los valores de entrada.

- El valor de las variables se proporciona en el archivo ``terraform.tfvars``.

<br>

#### PASO 2: definición de variables en ``variables.tf``

Este archivo es el encargado de declarar todas las variables de entrada que utilizará el módulo de Terraform, permitiendo así adaptar su comportamiento a las necesidades específicas de cada proyecto.

Cada variable incluye su **nombre**, **tipo de dato**, **descripción** y, en algunos casos, un **valor por defecto**.

Para este ejercicio, se definen cuatro variables necesarias para desplegar una ***Virtual Network (VNet)*** en Azure:

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
````

**Aspectos importantes**:

- La variable ``vnet_location`` tiene un valor por defecto (``West Europe``), lo que evita que sea obligatorio definirla en el archivo ``terraform.tfvars``.

- Se utiliza una lista de cadenas (``list(string)``) para la variable ``vnet_address_space``, ya que el atributo del recurso requiere una lista de rangos, incluso si solo se utiliza uno.

<br>

#### PASO 3: asignación de valores a las variables en ``terraform.tfvars``

En este archivo, se definen los valores específicos para las variables de entrada declaradas en el módulo. Gracias a este archivo, se puede personalizar la configuración sin necesidad de modificar los archivos principales.

En él, se proporcionan los valores para las variables declaradas en el archivo ``variables.tf``:

````terraform
# terraform.tfvars

existent_resource_group_name = "rg-rgarcia-dvfinlab"
vnet_name = "vnetrgarciatfexercise01"
vnet_address_space = ["10.0.0.0/16"]
````

**Aspectos importantes**:

- No se define el valor de ``vnet_location`` ya que presenta un valor por defecto en el archivo ``variables.tf``.

<br>

### Comprobación

Para comprobar que el código se ha creado correctamente, se ejecuta el comando ``terraform init`` para inicializar el entorno de Terraform:

````powershell
terraform init
````

![terraform init](/terraform/datos/ejercicio%202/ejercicio-2_1.1.png)

Posteriormente, se ejecutan los comandos ``terraform plan`` y ``terraform apply`` para crear los recursos de Azure:

````powershell
terraform plan
````

![terraform plan](/terraform/datos/ejercicio%202/ejercicio-2_1.2.png)


````powershell
terraform apply
````

![terraform apply](/terraform/datos/ejercicio%202/ejercicio-2_1.3.png)

Como se puede observar, los recursos solicitados se han creado correctamente en Azure y presentan los valores definidos en los archivos de configuración.

![recurso](/terraform/datos/ejercicio%202/ejercicio-2_1.4.png)

Para finalizar, se destruye el entorno de Azure mediante el comando ``terraform destroy``:

````powershell
terraform destroy
````

![terraform destroy](/terraform/datos/ejercicio%202/ejercicio-2_1.5.png)