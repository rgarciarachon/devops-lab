# Kubernetes
## Ejercicio 10

En este ejercicio, el objetivo es crear un *namespace* en Kubernetes utilizando un comando imperativo, establecer límites de recursos para ese espacio de manera declarativa y, finalmente, desplegar los recursos definidos en el ejercicio 8 dentro de este *namespace*. Para ello, será necesario modificar los manifiestos originales para que apunten correctamente al nuevo *namespace* y respeten las restricciones de recursos definidas.

### Paso 1: creación del namespace

El primer paso para llevar a cabo el ejercicio es crear el *namespace* en el clúster de Kubernetes. Esto se puede hacer mediante el siguiente comando:

````powershell
kubectl create namespace ej10
````

![Namespace](/kubernetes/datos/Ejercicio_10/ejercicio-10_1.1.png)

### Paso 2: configuración de límites de recursos y manifiesto ej08

Una vez creado el *namespace*, el siguiente paso consiste en establecer restricciones de uso de recursos (CPU y memoria) para los contenedores que se ejecuten en él. Esto se logra mediante la creación de un recurso de tipo ``LimitRange``, que permite definir límites máximos, mínimos, y valores por defecto tanto para las peticiones como para los límites de recursos que podrán utilizar los contenedores dentro del *namespace* ``ej10``.

A continuación se muestra el manifiesto del recurso:

````yaml
# limites.yaml

apiVersion: v1
kind: LimitRange
metadata:
  name: recursos
  namespace: ej10
spec:
  limits:
  - default: # Límite asignado por defecto si no se especifica
      memory: 1Gi
      cpu: "1"
    defaultRequest:
      memory: 0.5Gi
      cpu: "0.5"
    max: # Máximo permitido
      memory: 1Gi
      cpu: "1"
    min: # Mínimo permitido
      memory: 0.5Gi
      cpu: "0.5"
    type: Container
````

Posteriormente, se ha modificado el manifiesto del *Deployment* utilizado en el ejercicio 8 para que apunte al *namespace* ``ej10`` y respete los límites de recursos definidos anteriormente.

El manifiesto actualizado del *Deployment* es el siguiente:

````yaml
# deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: colors
  namespace: ej10
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

Una vez preparados ambos manifiestos (``limites.yaml`` y ``deployment.yaml``), se aplican al clúster mediante los siguientes comandos:

````powershell
kubectl apply -f .\limites.yaml
kubectl apply -f .\deployment.yaml
````

![Despliegue](/kubernetes/datos/Ejercicio_10/ejercicio-10_1.3.png)

![Comprobación de recursos](/kubernetes/datos/Ejercicio_10/ejercicio-10_1.4.png)

![Comprobación de límites](/kubernetes/datos/Ejercicio_10/ejercicio-10_1.2.png)

Como se puede observar en las capturas, tanto las restricciones de recursos como el despliegue del *Deployment* en el nuevo espacio de nombres se han realizado correctamente.

### Paso 3: escalado del *Deployment* a 0 réplicas

Como paso final del ejercicio, se busca conservar el recurso *Deployment* desplegado dentro del clúster de Kubernetes, pero sin que se encuentren *pods* en ejecución.

Para lograr esto, se realiza un escalado del número de réplicas a 0 utilizando el siguiente comando:

````powershell
kubectl scale deployment colors --replicas=0 -n ej10
````

![Resultado](/kubernetes/datos/Ejercicio_10/ejercicio-10_1.5.png)

Una vez aplicado el cambio, se puede comprobar el estado del sistema utilizando un comando como ``kubectl get all -n ej10``. En la salida se observa que el *Deployment* sigue definido en el clúster, aunque no haya *pods* corriendo.