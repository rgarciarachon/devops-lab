# Kubernetes
## Ejercicio 3

En este ejercicio, se debe crear un archivo de configuración YAML para desplegar un POD llamado ``apache-yaml``, utilizando la imagen oficial de ``httpd``. Además, el manifiesto debe incluir una política de reinicio que garantice que el POD se reinicie siempre que sea necesario.

Una vez desplegado el recurso, se deberá:

- Listar los POD mostrando toda la información posible
- Conectar el puerto del POD a un puerto del equipo para poder acceder a él
- Eliminar el POD creado

### Creación del archivo de configuración

Para realizar este ejercicio, se ha creado un archivo llamado ``pod-apache.yaml`` con el siguiente contenido:

````yaml
apiVersion: v1
kind: Pod
metadata:
  name: apache-yaml
spec:
  containers:
  - name: apache
    image: httpd
    ports:
    - containerPort: 80
  restartPolicy: Always # Política de reinicio
````

**Aspectos importantes**:

- Se especifica el puerto que expone el contenedor. Este paso es necesario para poder acceder al servicio web más adelante.

- Se define una política de reinicio que indica que el POD debe reiniciarse automáticamente en caso de fallo para mantener el servicio disponible. Aunque este comportamiento (``Always``) se aplica por defecto, incluirlo en el manifiesto ayuda a su comprensión e intención del despliegue.

Una vez configurado, se despliega el recurso en el clúster mediante el siguiente comando:

````powershell
kubectl create -f .\pod-apache.yaml
````

![Despliegue](/kubernetes/datos/Ejercicio_3/ejercicio-3_1.1.png)

<br>

A continuación, se realizan una serie de acciones para verificar y gestionar el POD creado.

### Listado de POD

Se listan los POD existentes en el clúster, mostrando toda la información posible disponible:

````powershell
kubectl get pods -o wide
````

![Listado de POD](/kubernetes/datos/Ejercicio_3/ejercicio-3_1.2.png)

Gracias a este comando, se obtiene una visión general del clúster, como puede ser el nodo donde se ejecuta, sin necesidad de entrar en la descripción.

### Comprobación del funcionamiento del contenedor

Cuando se despliega una imagen de **Apache HTTP Server** en un contenedor, es fundamental tener una forma de verificar que el servicio está activo y funcionando correctamente. Kubernetes ofrece distintas opciones según desde dónde se quiera acceder:

- Desde la máquina local

- Desde dentro del clúster

- Desde el exterior del clúster

En este caso concreto, se va a comprobar el funcionamiento del contenedor desde **fuera del clúster**, conectando el puerto del POD a un puerto local del equipo. Este método es útil para realizar pruebas rápidas, ya que permite acceder al servicio sin necesidad de configurar recursos adicionales como ``Services``.

Para redirigir el tráfico, se utiliza el comando ``kubectl port-forward``, que conecta el puerto del contenedor al puerto del equipo local:

````powershell
kubectl port-forward apache-yaml 8008:80
````

![Port-forward](/kubernetes/datos/Ejercicio_3/ejercicio-3_1.3.png)

Una vez realizada la redirección, se puede comprobar el funcionamiento del servicio accediendo a la siguiente URL desde el navegador:

````bash
http://localhost:8080
````

![Resultado](/kubernetes/datos/Ejercicio_3/ejercicio-3_1.4.png)

### Borrado del POD

Finalmente, una vez completadas las tareas, se elimina el POD para liberar recursos:

````powershell
kubectl delete pod/apache
````

![Eliminación de POD](/kubernetes/datos/Ejercicio_3/ejercicio-3_1.5.png)