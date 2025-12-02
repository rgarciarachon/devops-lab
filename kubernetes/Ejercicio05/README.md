# Kubernetes
## Ejercicio 5

En línea con el ejercicio anterior, se busca crear un manifiesto para desplegar un objeto *Deployment* llamado ``demogato-yaml``, utilizando la imagen ``tomcat:11.0.0-M20``. El contenedor dentro del *Deployment* llevará por nombre ``tomcat`` y utilizará la etiqueta ``app: gato`` con el fin de identificar y asociar correctamente los POD gestionados por este *Deployment*. Todo ello se realizará de forma declarativa.

Una vez desplegado, se deberá:

- Listar tanto los **POD** como los **Deployments** disponibles en el clúster.

### Creación del Deployment en modo declarativo

Para realizar este ejercicio, se ha creado un archivo llamado ``pod-demogato.yaml`` con el siguiente contenido:

````powershell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demogato-yaml
  labels: # Etiquetas de organización
    app: gato
spec:
  replicas: 1 # Número de pods que se desplegaran
  selector: # Permite buscar objetos que cumplan con las condiciones del selector
    matchLabels: # Localiza objetos que tengan las etiquetas indicadas
      app: gato # Gestiona los pods que tengan la etiqueta "app: gato"
  template: # Define la plantilla del pod
    metadata:
      labels:
        app: gato
    spec:
      containers:
      - name: tomcat
        image: tomcat:11.0.0-M20
        ports:
        - containerPort: 80
````

**Aspectos importantes**:

- Se utilizan las etiquetas ``app: gato`` en tres partes del manifiesto:

  - En el propio *Deployment*, para identificarlo y facilitar la gestión desde la consola.

  - En el campo ``selector:``, que le indica al *Deployment* qué PODs debe controlar, es decir, solo gestionará aquellos que tengan la etiqueta ``app: gato``.

  - En los PODs, para que Kubernetes pueda reconocerlos y asociarlos al *Deployment* correctamente.

Una vez desplegado, se realizan algunas acciones básicas para comprobar que todo está funcionando como se espera.

Primero, se listan los *Deployments* disponibles en el clúster mediante el siguiente comando:

````powershell
kubectl get deploy -o wide
````

Posteriormente, se listan los POD disponibles en el clúster mediante el siguiente comando:

````powershell
kubectl get pods -o wide
````

![resultado](/kubernetes/datos/Ejercicio_5/ejercicio-5_1.1.png)

En este caso, no se eliminará el recurso, ya que se reutilizará en el siguiente ejercicio.