# Kubernetes

Kubernetes es una plataforma que facilita el despliegue, escalado y gestión de aplicaciones en contenedores de forma automática. Para utilizar **Kubernetes** en un entorno local, una opción común es **Minikube**, que permite crear un clúster simulado en la máquina, integrando tanto el nodo maestro como los nodos trabajadores en un único entorno.

Para poder interactuar con dicho clúster, se utiliza la herramienta de línea de comandos llamada ``kubectl``, que actúa como intermediaria entre el entorno local y el clúster.

## Ejercicio 1

En este ejercicio se busca crear un POD llamado ``apache`` utilizando la imagen ``httpd``, todo ello de forma **imperativa**, es decir, directamente desde la línea de comandos sin utilizar archivos de configuración. Posteriormente, se deberá:

- Listar los POD existentes
- Describir en detalle el POD creado
- Eliminar el POD creado

Estos pasos ayudan a comprender el ciclo de vida básico de un POD y cómo interactuar con él utilizando **kubectl**.

### 1. Instalación de minikube y kubectl

El primer paso para realizar el ejercicio es instalar las herramientas necesarias, que incluyen:

- Docker
- Minikube
- Kubectl

Dado que **Docker** ya se ha utilizado en módulos anteriores, solo será necesario instalar **Minikube** y **Kubectl**. Para ello, se han seguido las guías oficiales: [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download) y [kubectl](https://kubernetes.io/docs/tasks/tools/).

A continuación, se detallan los pasos realizados a través de la consola, comenzando con la instalación de Minikube:

``Minikube``

1. Descargar el instalador de Minikube para Windows.

    ````powershell
    New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
    Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
    ````

    ![instalador](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.5.png)

2. Añadir la ruta de instalación a las variables de entorno.

    ````powershell
    $oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
    if ($oldPath.Split(';') -inotcontains 'C:\minikube'){
    [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
    }
    ````

    ![ruta](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.6.png)

3. Iniciar Minikube utilizando **Docker** como *driver* y configurarlo para que, por defecto, emplee **Docker** como *driver* para el clúster.

    **Importante**: es necesario tener Docker Desktop instalado y en funcionamiento para que pueda ser detectado.

    ````powershell
    minikube start --driver=docker
    minikube config set driver docker
    ````

    ![instalador](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.7.png)

    ![contenedor](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.12.png)

<br>

El siguiente paso consiste en interactuar con el clúster creado, lo cual requiere tener instalado **kubectl**. A continuación, se detallan los pasos para su instalación:

``kubectl``

1.  Instalar **kubectl** en Windows mediante el paquete de gestión **winget**.

    ````powershell
    winget install -e --id Kubernetes.kubectl
    ````

    ![instalación](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.1.png)

2.  Verificar que **kubectl** se haya instalado correctamente.

    ````powershell
    kubectl version --client
    ````

    ![verificación](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.2.png)

3. Navegar al directorio ``home`` y crear un nuevo directorio llamado ``.kube``.

    ````powershell
    cd ~
    mkdir .kube
    ````

    ![directorio .kube](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.3.png)

4. Una vez dentro del directorio creado, configurar **kubectl** para utilizar un clúster de Kubernetes remoto.

    ````powershell
    New-Item config -type file
    ````

    ![configuración de kubectl](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.4.png)

<br>

### 2. Creación del POD en modo imperativo

Una vez instaladas las herramientas necesarias, se puede proceder con la creación del POD.

Para ello, se utiliza el comando ``kubectl run``, que permite definir el nombre del POD y la imagen que se desea utilizar.

````powershell
kubectl run <nombre> --image=<imagen>
kubectl run apache --image=httpd
````

![creación del POD](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.8.png)

A continuación, se realizan una serie de acciones para verificar y gestionar el POD creado.

Primero, se listan los PODs disponibles en el clúster con el siguiente comando:

````powershell
kubectl get pods
````

![obtener POD](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.9.png)

Luego, se obtiene información detallada del POD mediante el comando:

````powershell
kubectl describe pod/apache
````

![describir POD](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.10.png)

Finalmente, una vez completadas las tareas, se elimina el POD para liberar recursos:

````powershell
kubectl delete pod/apache
````

![eliminar POD](/kubernetes/datos/Ejercicio_1/ejercicio-1_1.11.png)