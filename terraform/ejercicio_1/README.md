# Terraform
## Ejercicio 1

### Instalación de Terraform

Terraform es una herramienta de infraestructura como código que permite definir, aprovisionar y gestionar recursos de nube (como redes, servidores o bases de datos) mediante archivos de configuración declarativos.

Antes de comenzar a trabajar con Terraform, es necesario realizar su instalación en el entorno local. Pese a no tratarse de un ejecutable al uso, se trata de un proceso sencillo que consiste en lo siguiente:

1. Descargar el ejecutable correspondiente a nuestro sistema operativo en la página oficial.
2. Una vez descargado, descomprimir el archivo para obtener el ``.exe``.
3. Ubicar el archivo en ``C:\Program Files\Terraform``.
4. Incluir la ruta al ejecutable en las variables de entorno del sistema.

<br>

![Instalación Terraform](/terraform/datos/ejercicio%201/ejercicio-1_1.3.png)

A continuación, se comprueba que se ha instalado correctamente:

![Comprobación instalación](/terraform/datos/ejercicio%201/ejercicio-1_1.5.png)

### Configuración inicial: Azure CLI

A partir de este punto, será necesario utilizar **Azure**, la plataforma de computación en la nube de **Microsoft**, que permite crear, implementar y administrar aplicaciones y servicios a través de Internet. Se trata del entorno en el que Terraform despliega y administra los recursos.

Para interactuar con Azure desde la terminal, se requiere instalar **Azure CLI** (*Command-Line Interface*), una herramienta que facilita la gestión de recursos directamente desde la línea de comandos.

Cuando se trabaja con Terraform en entornos de Azure, Azure CLI se encarga de preparar el entorno y simplificar el proceso de autenticación, por lo que el siguiente paso consistirá en su configuración.

**Requisito previo**: disponer de una cuenta de Azure.


Para instalar Azure CLI, se debe abrir **PowerShell en modo admnistrador** y ejecutar el siguiente comando:

````powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
````

Este comando descargará e instalará Azure CLI de forma silenciosa.

![Resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.4.png)

A continuación, se debe ejecutar el siguiente comando para permitir que Terraform se autentique con Azure. Durante el proceso, se abrirá una ventana del navegador solicitando iniciar sesión con la cuenta de Azure.

````powershell
az login
````

![Selección de cuenta](/terraform/datos/ejercicio%201/ejercicio-1_1.6.png)

Una vez iniciada la sesión, la terminal mostrará un listado con las cuentas de suscripción disponibles. Se seleccionará la cuenta con la que queramos acceder y se introducirá el número correspondiente.

![Cuentas](/terraform/datos/ejercicio%201/ejercicio-1_1.1.png)

Finalmente, se establecerá la suscripción seleccionada en Azure CLI mediante el siguiente comando:

````powershell
az account set --subscription "id***"
````

### Obtener valores del Service Principal y de la suscripción

Para que Terraform pueda interactuar con los recursos de Azure y disponer de un acceso controlado a los recursos sin necesidad de utilizar una cuenta personal, es necesario configurar ciertas variables de entorno que faciliten la autenticación y definan el contexto de la suscripción.

Las variables en cuestión son:

- ``ARM_CLIENT_ID``: app ID del Service Principal
- ``ARM_CLIENT_SECRET``: contraseña del Service Principal
- ``ARM_TENANT_ID``: ID del tenant de la cuenta de Azure
- ``ARM_SUBSCRIPTION_ID``: ID de la suscripción de Azure

<br>

En primer lugar, se ejecutará el siguiente comando, con el cual se indica a Azure que busque un Service Principal que contenga el nombre de usuario y muestre el resultado en una tabla con el nombre visible y el identificador de la aplicación (``appId``).

````powershell
 az ad sp list --all --query "[?contains(displayName, 'rgarcia')].{name:displayName, appId:appId}" -o table
````

![Resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.7.png)

Una vez obtenido el ``appId``, se procederá a consultar el ``tenantId`` y el ``subscriptionId``. Estos dos identificadores no pertenecen al Service Principal, sino que son propios de la cuenta de Azure en la que se está trabajando. Para ello, se utilizará el siguiente comando, que solicita a Azure los datos correspondientes y presenta el resultado en forma de tabla.

````bash
az account show --query "{tenantId:tenantId, subscriptionId:id}" -o table
````

![resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.9.png)


La contraseña asociada al Service Principal no puede consultarse desde la terminal, por lo que es necesario obtenerla a través del portal de Azure. Para ello, se deben seguir los siguientes pasos:

- Acceder al apartado **Todos los recursos**.
- Seleccionar el recurso correspondiente al almacén de claves.
- En el menú desplegable **Objetos**, acceder a la sección **Secretos**.
- Seleccionar el secreto que corresponde a la cuenta y a la versión deseada.

<br>

![resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.10.png)

Una vez obtenidos todos los datos necesarios, deberán configurarse como variables de entorno. Esto permitirá que Terraform se autentique correctamente y disponga de los permisos requeridos para operar sobre los recursos de Azure.

````powershell
$Env:ARM_CLIENT_ID = "<APPID_VALUE>"
$Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
$Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
$Env:ARM_TENANT_ID = "<TENANT_VALUE>"
````

![resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.11.png)

Por último, para verificar que la configuración es correcta, se ha creado un archivo denominado ``main.tf``. Mediante este archivo se puede comprobar la conexión entre Terraform y Azure, y confirmar que la autenticación mediante el Service Principal se ha realizado correctamente.

````powershell
terraform init
````

![resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.12.png)

````powershell
terraform plan
````

![resultado](/terraform/datos/ejercicio%201/ejercicio-1_1.13.png)