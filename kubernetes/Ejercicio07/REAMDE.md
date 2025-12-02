# Kubernetes
## Ejercicio 7

Este ejercicio tiene como objetivo practicar el despliegue de una aplicación en Kubernetes a partir de una imagen de Docker personalizada.

Para ello, se parte del código fuente de una aplicación web sencilla, que se empaqueta en una imagen mediante un ``Dockerfile``. Una vez creada la imagen, se despliega en el clúster de Kubernetes, creando los recursos necesarios para que funcione correctamente.

### Paso 1: organización de los archivos de trabajo

El ejercicio comienza con la preparación de una carpeta de trabajo denominada ``/ficheros``, que contiene los recursos necesarios para el despliegue de una aplicación web. En su interior se encuentran:

- Una carpeta ``/web``, que contiene los archivos de una página web básica:

    ````powershell
    ├── web/
        │ index.html
        │ responsive.css
        │ style.css
        │
        ├── css/
        ├── fonts/
        ├── img/
        └── js/
    ````

- Un archivo ``Dockerfile``, que contiene las instrucciones para construir una imagen de Docker personalizada.

- Un manifiesto YAML que agrupa los recursos necesarios para el despliegue en Kubernetes.

<br>

### Paso 2: creación de la imagen de Docker

Se parte del siguiente *Dockerfile*, el cual define una imagen basada en Ubuntu:

````dockerfile
FROM ubuntu
RUN apt-get update
RUN apt-get install -y apache2
ADD web /var/www/html
EXPOSE 80
CMD /usr/sbin/apachectl -D FOREGROUND
````

Este archivo configura una imagen que instala Apache2, copia los archivos de la carpeta ``/web`` al directorio raíz del servidor web (``/var/www/html``) y expone el puerto 80. Finalmente, inicia Apache en primer plano para mantener activo el contenedor.

Para generar la imagen, se ejecuta el siguiente comando:

````powershell
dockder build -t rgarcia/web .
````

![Imagen docker](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.1.png)

Tras la ejecución del comando, se comprueba que la imagen se ha construido correctamente, como se muestra a continuación:

![Imagen docker](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.2.png)

<br>

### Paso 3: comprobación de la imagen en entorno Docker

Una vez creada la imagen, y antes de desplegarla en Kubernetes, se comprueba su correcto funcionamiento ejecutándola manualmente con Docker y accediendo a la aplicación desde el navegador.

Para ello, se ejecuta el siguiente comando:

````powershell
docker run --name web -d -p 9090:80 rgarcia/web
````

![Docker run](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.3.png)

Gracias a la redirección del puerto 9090 al puerto 80 del contenedor, es posible abrir la aplicación web en el navegador y comprobar que funciona correctamente.

````bash
localhost:9090
````

![Resultado](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.4.png)

<br>

### Paso 4: despliegue de la aplicación en Kubernetes

Antes de proceder con el despliegue en Kubernetes, se decidió subir la imagen generada a Docker Hub. Esto permite que el clúster pueda acceder fácilmente a la imagen desde cualquier nodo, sin depender de recursos locales. Además, se optó por utilizar una imagen propia en lugar de la proporcionada por el instructor del curso de Udemy.

Para ello, se etiquetó la imagen local con el nombre de usuario correspondiente en Docker Hub:

````powershell
docker tag rgarcia/web rgarciarachon/web:v1
````

Una vez etiquetada, se procedió a subirla a la plataforma:

````powershell
docker push rgarciarachon/web:v1
````

![Etiquetado y subida a Docker Hub](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.6.png)

![Docker Hub](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.10.png)

Finalmente, una vez que la imagen está disponible en el repositorio, se pasa a la fase de despliegue en Kubernetes. Para ello, se crea un único archivo de manifiesto que incluye tanto el recurso *Deployment*, encargado de crear y gestionar los *pods* de la aplicación, como el *Service*, que expone la aplicación dentro del clúster para que se pueda acceder a ella desde el exterior.

````yaml
# DEPLOYMENT  

apiVersion: apps/v1 
kind: Deployment
metadata:
  name: web-d
spec:
  selector:
    matchLabels:
      app: web
  replicas: 2
  template:   
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: apache
        image: rgarciarachon/web:v1
        ports:
        - containerPort: 80
---

# SERVICIO

apiVersion: v1
kind: Service
metadata:
  name: web-svc
  labels:
    app: web
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30002
    protocol: TCP
  selector:
    app: web
````

Con el archivo completo, se aplica el manifiesto al clúster ejecutando el siguiente comando:

````powershell
kubectl apply -f .\completo.yaml
````

A continuación, se verifican los recursos creados:

````powershell
kubectl get pods
kubectl get svc
````

![Resultado](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.7.png)

### Paso 5: comprobación del funcionamiento de la aplicación

Como paso final, se verifica que la aplicación se haya desplegado correctamente y que sea accesible desde el navegador. Para ello, se utiliza el siguiente comando, que abre un túnel hacia el servicio expuesto:

````powershell
minikube service web-svc
````

![Resultado](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.8.png)

![Resultado](/kubernetes/datos/Ejercicio_7/ejercicio-7_1.9.png)

Al ejecutarlo, se abre automáticamente una pestaña del navegador con la dirección correspondiente. Tal y como se muestra en las capturas, la aplicación web carga correctamente, lo que confirma que el despliegue ha tenido éxito y que la imagen funciona tal y como se esperaba.