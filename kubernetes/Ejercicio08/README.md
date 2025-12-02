# Kubernetes
## Ejercicio 8

En este ejercicio, se busca desplegar una aplicación en Kubernetes utilizando manifiestos declarativos.

### Paso 1: creación y despliegue de los recursos

En primer lugar, se define un recurso *Deployment* con las siguientes características:

````yaml
# deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: colors
spec:
  replicas: 3
  selector:
    matchLabels:
      app: colors
  template:
    metadata:
      labels:
        app: colors
    spec:
      containers:
        - name: coloread
          image: noloknolo/colors:v1
          ports:
          - containerPort: 8080
````

Para determinar el puerto utilizado por la imagen, se consultó el repositorio de origen. En el archivo *Dockerfile*, se observa que la aplicación expone el puerto 8080:

![Puerto](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.1.png)

A continuación, se crea un recurso *Service* de tipo *ClusterIP* para exponer el despliegue dentro del clúster:

````yaml
# service.yaml

apiVersion: v1
kind: Service
metadata:
  name: colors-service
spec:
  type: ClusterIP
  selector:
    app: colors
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
````

![Despliegue](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.2.png)

![Comprobación](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.3.png)

Una vez aplicados ambos manifiestos, se puede comprobar que tanto los pods como el servicio se han creado correctamente.

### Paso 2: comprobación del funcionamiento de la apliación

Finalmente, se verifica que la aplicación funciona correctamente. Para ello, se crea un túnel de red entre el clúster y la máquina local con el siguiente comando:

````powershell
minikube service colors-service
````

![Minikube service](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.4.png)

![Resultado](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.5.png)

![Resultado](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.6.png)

![Resultado](/kubernetes/datos/Ejercicio_8/ejercicio-8_1.7.png)

Como se observa en las capturas, la aplicación se ha desplegado correctamente y es accesible desde el navegador. La aplicación muestra colores aleatorios junto con el mensaje:

````bash
Hello from <nombre del pod>!
````

Dado que se han creado 3 réplicas, cada vez que se actualiza la página, la solicitud se atiende desde un pod diferente, mostrando así distintos mensajes y colores.