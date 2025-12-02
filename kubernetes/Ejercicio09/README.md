# Kubernetes
## Ejercicio 9

Este ejercicio tiene como objetivo desplegar una aplicación web con una arquitectura cliente-servidor basada en Redis, donde el maestro manejará las escrituras y se podrá acceder a él mediante el frontend en PHP.

### Paso 1: creación y despliegue del Redis maestro

El primer paso consiste en desplegar una instancia principal de Redis. Para ello, se crea un manifiesto de tipo *Deployment* con la siguiente configuración:

````yaml
# redis-leader.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-leader
  labels:
    app: redis
    role: leader
    tier: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
        role: leader
        tier: backend
    spec:
      containers:
      - name: leader
        image: "docker.io/redis:6.0.5"
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
````

Este archivo define un único *pod* que utiliza la imagen oficial de Redis, expuesto en su puerto predeterminado (6379). También incluye algunas solicitudes de recursos mínimas para asegurar su funcionamiento.

Una vez definido el manifiesto, se aplica al clúster con el siguiente comando:

````powershell
kubectl apply -f ./redis-leader.yaml
````

Para confirmar que todo se ha creado correctamente, se listan los recursos tanto de forma general como utilizando filtros por etiquetas:

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.1.png)

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.2.png)

Una vez desplegado el componente maestro, el siguiente paso será crear el *Service* para exponer el Redis dentro del clúster.

Para ello, se define el siguiente manifiesto:

````yaml
# redis-leader-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: redis-leader
  labels:
    app: redis
    role: leader
    tier: backend
spec:
  ports:
  - port: 6379
    targetPort: 6379
  selector:
    app: redis
    role: leader
    tier: backend
````

Este archivo configura un servicio interno (de tipo *ClusterIP* por defecto) que enlaza con el *Deployment* previamente creado, utilizando las mismas etiquetas para garantizar que se dirija al *pod* correcto.

Una vez creado el manifiesto, se aplica al clúster con el siguiente comando:

````powershell
kubectl apply -f redis-master-service.yaml
````

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.3.png)

<br>

### Paso 2: comprobación del servicio desde el interior del Pod

Para comprobar que el servicio está funcionando correctamente y se comunica con el *pod*, se pueden revisar sus detalles. En ellos se observa que el servicio se ha vinculado correctamente a una dirección IP y un puerto, los cuales corresponden con los del *pod* del componente maestro. 

![IP](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.4.png)

Una forma sencilla de verificar la conexión es acceder directamente al *pod* y consultar el archivo ``hosts``, donde deberían figurar las asociaciones de nombres con direcciones IP:

````powershell
kubectl exec -it <nombre-pod> bash
````

````powershell
cat /etc/hosts
````

![IP](/datos/Ejercicio_9/ejercicio-9_1.5.png)

De este modo, se confirma que el nombre del servicio (``redis-leader``) se resuelve correctamente dentro del clúster, lo que garantiza la conectividad entre componentes.

<br>

### Paso 3: creación y despliegue los esclavos

El siguiente paso consiste en desplegar los *pods* esclavos (o réplicas) de Redis, que trabajarán junto con el *pod* maestro configurado previamente. El objetivo es implementar dos réplicas que se conecten automáticamente al *pod* maestro para sincronizar sus datos y mejorar la capacidad de lectura del sistema.

Para ello, se define el siguiente manifiesto:

````yaml
# redis-follower.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-follower
  labels:
    app: redis
    role: follower
    tier: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
        role: follower
        tier: backend
    spec:
      containers:
      - name: follower
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-redis-follower:v2
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
````

Una vez creado el manifiesto, se aplica al clúster con el siguiente comando:

````powershell
kubectl apply -f redis-follower.yaml
````

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.6.png)

![Comprobación de recursos](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.7.png)

Como se puede comprobar en la imagen, los recursos se han creado correctamente y ya están funcionando en el clúster.

A continuación, se crea un *Service* para exponer los *pods* esclavos dentro del clúster:

````yaml
# redis-follower-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: redis-follower
  labels:
    app: redis
    role: follower
    tier: backend
spec:
  ports:
  - port: 6379
  selector:
    app: redis
    role: follower
    tier: backend
````

Este servicio utiliza las etiquetas para conectar correctamente con los *pods* definidos en el *Deployment* de los esclavos. Una vez creado, bastará con aplicar el manifiesto para que quede disponible en el clúster:

````powershell
kubectl apply -f redis-follower-service.yaml
````

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.8.png)

Con esto, tanto el maestro como los esclavos están desplegados y accesibles mediante sus respectivos servicios.

<br>

### Paso 4: creación y despliegue del *frontend*

Llegado a este punto, solo quedaría crear el *frontend*, que es la interfaz visible de la aplicación para los usuarios. Este *frontend* se conecta con los servicios de Redis maestro y esclavos previamente desplegados para mostrar y actualizar la información.

El manifiesto del *Deployment* contiene la siguiente configuración:

````yaml
# frontend.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
        app: guestbook
        tier: frontend
  template:
    metadata:
      labels:
        app: guestbook
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5
        env:
        - name: GET_HOSTS_FROM
          value: "dns"
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 80
````

Una vez creado el manifiesto, se aplica al clúster mediante el siguiente comando:

````powershell
kubectl apply -f frontend.yaml
````

Además, se comprueba que el *Deployment* y los *pods* se hayan creado correctamente, ya sea de forma general o filtrando por etiquetas.

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.10.png)

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.11.png)

Una vez el *Deployment* está desplegado, se crea un *Service* para exponer el *frontend* fuera del clúster, permitiendo que los usuarios puedan acceder a la aplicación desde el navegador.

El manifiesto del servicio es el siguiente:

````yaml
# frontend-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  type: NodePort
  ports:
  - port: 80
  selector:
    app: guestbook
    tier: frontend
````

Una vez creado el manifiesto, se aplica al clúster mediante el siguiente comando:

![Despliegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.12.png)

<br>

### Paso 5: comprobación del funcionamiento de la aplicación

Finalmente, para verificar que la aplicación está funcionando correctamente, se accede al servicio *frontend* desde la máquina local usando:

````powershell
minikube service frontend
````

![Resultado](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.14.png)

![DesplResultadoiegue](/kubernetes/datos/Ejercicio_9/ejercicio-9_1.13.png)

Como se observa en las capturas, la aplicación se ha desplegado con éxito y es accesible desde el navegador. Se trata de una aplicación que interacciona con el *backend* Redis para almacenar y mostrar mensajes o datos en tiempo real.