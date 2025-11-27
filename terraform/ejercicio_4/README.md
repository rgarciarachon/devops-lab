# Terraform
## Ejercicio 4

En este ejercicio, se debe modificar la configuración anterior para cumplir con los siguientes requisitos:

- Las variables ``owner_tag``, ``environment_tag`` y ``vnet_name`` no deben permitir valores nulos ni cadenas vacías.

- El valor de ``environment_tag`` debe coincidir con uno de los siguientes valores permitidos: ``DEV``, ``PRO``, ``TES`` o ``PRE``, sin importar si se utilizan mayúsculas o minúsculas.

- La variable ``vnet_tags`` debe ser un mapa no nulo, cuyos valores no pueden ser nulos ni cadenas vacías.

- El valor de ``vnet_name`` debe cumplir una de las siguientes condiciones: comenzar con el prefijo ``vnet``, o bien iniciar con ``vnet`` seguido de al menos tres letras minúsculas ([a-z]) y terminar con ``tfexercise`` seguido de al menos dos dígitos numéricos.

### Validación y configuración de variables

A través de este ejercicio, se busca reforzar el control de calidad de la infrestructura mediante reglas que aseguren la integridad de los valores definidos. Para ello, se utilizarán funciones propias de Terraform para validar el formato, el contenido y la estructura de los datos.

<br>

1. **PRIMER REQUISITO**:

Para cumplir con el primer requisito, se utilizará un **bloque de validación** en Terraform, el cual permite definir una condición mediante el atributo ``condition`` que asegura que las variables siempre tengan un valor válido. Si alguna de las variables no cumple con esta condición, se generará un mensaje de error personalizado mediante el atributo ``error_message``.

La expresión dentro del atributo ``condition`` evalúa la condición especificada, y, en este caso, se emplea la función ``length`` para asegurar que la longitud de la cadena sea mayor a 0, lo que garantiza que las variables no sean nulas ni vacías.

````terraform
# variables.tf
# Control de valores nulos y cadenas vacías

variable "vnet_name" {
    description = "Nombre de la vnet."
    type = string

    validation {
        condition     = length(var.vnet_name) > 0
        error_message = "El vnet_name no puede ser una cadena vacía."
    }
}

variable "owner_tag" {
    description = "Describe el propietario de la vnet."
    type = string

    validation {
        condition     = length(var.owner_tag) > 0
        error_message = "El owner_tag no puede ser una cadena vacía."
    }
}

variable "environment_tag" {
    description = "Describe el entorno de la vnet."
    type = string

    validation {
        condition     = length(var.environment_tag) > 0
        error_message = "El environment_tag no puede ser una cadena vacía."
    }
}
````

<br>

2. **SEGUNDO REQUISITO**:

Para cumplir con el segundo requisito, se incluye la función ``contains`` dentro del bloque de validación de ``environment_tag`` , que verifica si el valor de la variable está presente en una lista predefinida de valores válidos.

````terraform
contains(list, value)
````

La función ``contains`` espera recibir dos argumentos en un orden específico: primero, un conjunto de valores y, segundo, el valor que se desea buscar en dicho conjunto.

Como segundo argumento, se ha utilizado la función ``lower()``, que convierte la variable ``var.environment_tag`` en minúsculas. Esto resuelve la sensibilidad a mayúsculas y minúsculas.

<br>

````terraform
# variables.tf
# Control de valores permitidos

variable "environment_tag" {
    description = "Describe el entorno de la vnet."
    type = string

    validation {
        condition     = length(var.environment_tag) > 0 && contains(["dev", "pro", "tes", "pre"], lower(var.environment_tag))
        error_message = "El environment_tag no puede ser una cadena vacía y debe contener uno de los siguientes valores: DEV, PRO, TES o PRE."
    }
}
````

<br>

3. **TERCER REQUISITO**

Para cumplir con el tercer requisito, se definirá un bloque de validación para la variable ``vnet_tags``, con el objetivo de asegurar que tanto el mapa como los valores que contiene no sean nulos ni cadenas vacías.

Dentro del atributo ``condition``, se utilizan dos funciones anidadas: ``length()`` y ``keys()``. La función ``keys()`` obtiene la lista de claves del mapa, y al combinarla con ``length()``, se puede comprobar que el número de claves sea mayor que cero, lo que confirma que el mapa no está vacío.

Además, se utiliza la función ``alltrue()`` junto con una expresión ``for`` para recorrer todos los valores del mapa y verificar que ninguno sea nulo ni contenga cadenas vacías, garantizando así la validez de todos los elementos del conjunto.

````terraform
alltrue(list)
````

La función ``alltrue()`` recibe una lista como parámetro. En este caso y tal y como se ha mencionado anteriormente, se emplea una expresión de tipo bucle para generar esa lista y evaluar cada uno de sus elementos.

<br>

````terraform
# variables.tf
# Control de valores nulos y cadenas vacías

variable "vnet_tags" {
    description = "Describe los tags adicionales que se aplicarán a la vnet."
    type = map(string)
    default = {} # Valor vacío por defecto

    validation {
        # Asegura que el vnet_tags no sea un mapa vacío
        # Asegura que ninguno de los valores del mapa sea una cadena vacía
        condition     = length(keys(var.vnet_tags)) > 0 && alltrue([for i in var.vnet_tags : i != "" && i != null])
        error_message = "La variable vnet_tags no puede contener valores nulos ni cadenas vacías."
    }
}
````

4. **CUARTO REQUISITO**

Para cumplir con el último requisito, se debe añadir un bloque de validación a la variable ``vnet_name`` que asegure que el nombre de la red virtual comience con el prefijo ``vnet``. Para ello, se utiliza la función ``startswith()``, la cuál evalúa si una cadena comienza con un prefijo determinado.

````terraform
startswith(string, prefix)
````

Dicha función recibe dos parámetros de entrada: primero, la cadena que se va a evaluar y, segundo, el prefijo que se desea comprobar. En este caso, se utiliza la variable ``var.vnet_name`` como primer parámetro, ya que contiene el valor especificado en el archivo de configuración.

<br>

````terraform
# variables.tf
# Control de patrones requeridos

variable "vnet_name" {
    description = "Nombre de la vnet."
    type = string

    validation {
        # Asegura que el vnet_name cumpla con el patrón requerido
        condition     = startswith(var.vnet_name, "vnet")
        error_message = "El valor de vnet_name debe comenzar con el prefijo 'vnet'."
    }
}
````

<br>

### Comprobación

Para comprobar su correcta implementación, se procede a utilizar los siguientes comandos:

````terraform
terraform init
````

![init](/terraform/datos/ejercicio%204/ejercicio-4_1.1.png)

````terraform
terraform plan
````

![plan](/terraform/datos/ejercicio%204/ejercicio-4_1.2.png)

````terraform
terraform apply
````

![apply](/terraform/datos/ejercicio%204/ejercicio-4_1.3.png)

Como se puede observar, la implementación se ha realizado correctamente y se ha creado la red virtual con los valores especificados.

![azure](/terraform/datos/ejercicio%204/ejercicio-4_1.4.png)


### Validación de errores

Como verificación final, se han introducido intencionadamente valores incorrectos para validar el correcto funcionamiento de los distintos bloques de validación.

![errores](/terraform/datos/ejercicio%204/ejercicio-4_1.5.png)