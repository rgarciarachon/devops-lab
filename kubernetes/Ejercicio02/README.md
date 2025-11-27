# Kubernetes
## Ejercicio 2

En línea con el ejercicio anterior, se busca crear un POD llamado ``apache`` utilizando la imagen ``httpd``. Sin embargo, en esta ocasión el despliegue debe realizarse de forma **declarativa**, es decir, mediante el uso de un archivo de configuración en formato YAML. Posteriormente, se deberá:

- Listar los POD existentes
- Describir en detalle el POD creado
- Eliminar el POD creado

### Creación del POD de forma declarativa

Para realizar este ejercicio, se ha creado un archivo llamado ``pod-apache.yaml`` con el siguiente contenido:

````yaml
apiVersion: v1 # Versión de Kubernetes
kind: Pod # Recurso que se está creando
metadata:
  name: apache # Nombre del recurso
spec: # Especificaciones del contenido del recurso
  containers: # Contenedores dentro del pod
  - name: apache
    image: httpd:latest
    ports: # Lista de puertos que expone el contenedor
    - containerPort: 80
````

Una vez definido el manifiesto, el siguiente paso es desplegar el recurso en el clúster. Para ello, se pueden usar dos comandos:

1. ``create``

    ````powershell
    kubectl create -f .\pod-apache.yaml
    ````

    El comando ``create`` sirve para generar un recurso nuevo a partir del manifiesto. Si el recurso ya existe, se producirá un error, ya que este método no permite actualizaciones. Es una opción más estricta y directa.

2. ``apply``

    ````powershell
    kubectl apply -f .\pod-apache.yaml
    ````

    En cambio, el comando ``apply`` permite tanto crear el recurso si no existe, como actualizarlo si ya está presente. Compara el contenido del manifiesto con el estado actual del recurso en el clúster y aplica solo los cambios necesarios, sin eliminarlo.

En ambos comandos, el parámetro ``-f`` se utiliza para indicar el archivo de configuración que contiene la definición del recurso que se va a desplegar.

En este caso, y siguiendo los vídeos propuestos, se ha decidido utilizar el comando ``create``, ya que el objetivo principal del ejercicio es familiarizarse con el uso de manifiestos y comandos básicos de **kubectl**, por lo que esta opción resulta adecuada para una primera toma de contacto.

### Comprobación del POD creado

A continuación, se realizan una serie de acciones para verificar y gestionar el POD creado.

Primero, se listan los PODs disponibles en el clúster con el siguiente comando:

````powershell
kubectl get pods
````

![](/kubernetes/datos/Ejercicio_2/ejercicio-2_1.1.png)

Luego, se obtiene información detallada del POD mediante el comando:

````powershell
kubectl describe pod/apache
````

![](/kubernetes/datos/Ejercicio_2/ejercicio-2_1.2.png)

Finalmente, una vez completadas las tareas, se elimina el POD para liberar recursos:

````powershell
kubectl delete pod/apache
````

![](/kubernetes/datos/Ejercicio_2/ejercicio-2_1.3.png)