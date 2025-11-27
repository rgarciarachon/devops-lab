# Terraform
## Ejercicio 6

En este ejercicio se parte del módulo desarrollado previamente, el cual debe subirse a un repositorio remoto en GitHub si aún no se ha hecho. A partir de ahí, se crea una nueva configuración de Terraform que consuma dicho módulo directamente desde el repositorio remoto.

Este enfoque permite desacoplar el módulo de su uso, fomentando la reutilización del código y la gestión centralizada desde repositorios externos.

### Creación del nuevo repositorio en Github

En primer lugar, para la realización de este ejercicio, se ha creado un nuevo repositorio público en Github denominado ``terraform-azurerm-vnet-module``. En él, se han añadido los siguientes archivos, recuperados del ejercicio anterior:

- main.tf
- outputs.tf
- terraform.tfvars
- variables.tf


### Configuración de los archivos

Una vez definida la estructura tanto remota como local, se modifica el archivo ``main.tf`` en el entorno local para sustituir la definición directa de recursos por una invocación al módulo almacenado en el repositorio remoto.

Para ello, se emplea la instrucción ``source``, indicando como valor la URL del repositorio de GitHub donde se encuentra el módulo.

````terraform
# Llamada al módulo remoto
module "az_vnet" {
    source = "github.com/ragarciarachon/terraform-azurerm-vnet-module.git"

    vnet_name                = var.vnet_name
    vnet_location            = var.vnet_location
    existent_resource_group_name = var.existent_resource_group_name
    vnet_address_space       = var.vnet_address_space

    owner_tag                = var.owner_tag
    environment_tag          = var.environment_tag
    vnet_tags                = var.vnet_tags
}
````

En cuanto al resto de los archivos, se han mantenido sin cambios, ya que no requieren ninguna modificación adicional para completar correctamente este ejercicio.

### Comprobación

Para comprobar que el código se ha creado correctamente, se ejecuta el comando ``terraform init`` para inicializar el entorno de Terraform:

````powershell
terraform init
````

![terraform init](/terraform/datos/ejercicio%206/ejercicio-6_1.1.png)

Posteriormente, se ejecutan los comandos ``terraform plan`` y ``terraform apply`` para crear los recursos de Azure:

````powershell
terraform plan
````

![terraform plan](/terraform/datos/ejercicio%206/ejercicio-6_1.2.png)


````powershell
terraform apply
````

![terraform apply](/terraform/datos/ejercicio%206/ejercicio-6_1.3.png)

![outputs](/terraform/datos/ejercicio%206/ejercicio-6_1.4.png)


Como se puede observar, los recursos solicitados se han creado correctamente en Azure y presentan los valores definidos en los archivos de configuración.

![recurso](/terraform/datos/ejercicio%206/ejercicio-6_1.5.png)

**ADICIONAL**: si se consulta el archivo ``modules.json`` del directorio ``.terraform``, se podrá comprobar que el recurso se ha creado a partir del repositorio.

````json
"Source":"git::https://github.com/ragarciarachon/terraform-azurerm-vnet-module.git"
````