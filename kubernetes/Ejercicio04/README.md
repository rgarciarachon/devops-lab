# Kubernetes
## Ejercicio 4

En este ejercicio se busca dar un paso más y empezar a trabajar con los objetos **Deployment** en Kubernetes, que permiten gestionar **Pods** de forma más avanzada y controlada.

El objetivo es crear un **Deployment** llamado ``demogato`` de forma **imperativa**, utilizando la imagen oficial de ``tomcat``.

Una vez desplegado el recurso, se deberá:

- Listar los POD que ha creado automáticamente el Deployment
- Listar el Deployment actual para comprobar que se ha creado correctamente
- Eliminar el Deployment creado
- Verificar el estado de los POD tras eliminar el Deployment

### Creación del Deployment en modo imperativo

Para crear el *Deployment* desde la consola, se utiliza el comando ``kubectl create deployment``, que permite indicar tanto el nombre del recurso como la imagen que se desea utilizar:

````powershell
kubectl create deployment <nombre> --image=<imagen>
kubectl create deployment demogato --image=tomcat
````

Asimismo, se listan los *Deployment* disponibles para verificar su correcto despliegue.

````powershell
kubectl get deploy
````

![Deployment](/kubernetes/datos/Ejercicio_4/ejercicio-4_1.1.png)

Una vez desplegado, se realizan algunas acciones básicas para comprobar que todo está funcionando como se espera.

Primero, se listan los *Pods* disponibles en el clúster mediante el siguiente comando:

````powershell
kubectl get pods
````

![Pods](/kubernetes/datos/Ejercicio_4/ejercicio-4_1.2.png)

Como se puede ver, el *Deployment* se ha encargado automáticamente de crear un *Pod* con la imagen indicada.

Después, se procede a eliminar el *Deployment* para liberar recursos:

````powershell
kubectl delete deployment demogato
````

![Borrado](/kubernetes/datos/Ejercicio_4/ejercicio-4_1.3.png)

Al eliminar el *Deployment*, también se eliminan los *Pods* que había gestionado. Esto se puede confirmar listando nuevamente los *Pods*, donde ya no aparece ninguno asociado.

Esto ocurre debido a que los *Pods* creados a través de un *Deployment* están controlados por ese mismo objeto. Es decir, el *Deployment* es el encargado de crear, mantener y escalar los *Pods* según lo que se defina en su configuración. Por lo tanto, al eliminar el *Deployment*, Kubernetes elimina automáticamente todos los *Pods* que dependían de él.