# Kubernetes
## Ejercicio 6

Partiendo del *Deployment* creado en el ejercicio anterior (``demogato-yaml``), se deberá escalar la aplicación en **tres etapas** y de tres manera diferentes, incrementando progresivamente el número de réplicas del *Deployment*: primero en 1 réplica adicional, luego en 2 réplicas más, y finalmente en 3 réplicas adicionales.

Después de cada operación de escalado, se deberá listar los *Pods* del clúster para comprobar que el número de réplicas se ha actualizado correctamente.

Antes de empezar, conviene tener claro qué son las réplicas en Kubernetes. Básicamente, cada réplica representa una instancia activa de la aplicación. Al definir un número de réplicas en un *Deployment*, lo que se le está indicando a Kubernetes es cuántas copias idénticas de ese *Pod* debe mantener activas al mismo tiempo.

Por tanto, cuando se escala un *Deployment*, lo que realmente se está haciendo es aumentar o reducir el número de esas instancias.

Gracias a ello, se consigue distribuir la carga de trabajo, mejorar el rendimiento y, además, ofrecer tolerancia a fallos.

### Modo 1: escalado manual mediante consola

El primer método permite modificar el número de réplicas directamente desde la línea de comandos. Es útil cuando se necesita escalar de forma rápida y puntual, sin tocar el archivo de configuración.

Eso sí, hay que tener en cuenta que se trata de un modo **no declarativo**, lo que significa que los cambios no se reflejan en el archivo de configuración. Por lo tanto, si más adelanta se vuelve a aplicar ese archivo, se perderán los ajustes realizados desde consola.

Para escalar con este método se utiliza el siguiente comando:

````powershell
kubectl scale deploy <nombre> --replicas=<número>
kubectl scale deploy demogato-yaml --replicas=2
````

![consola](/kubernetes/datos/Ejercicio_6/ejercicio-6_1.1.png)

Como se puede observar, inicialmente solo había un *Pod*, y tras aumentar el número de réplicas a **2**, Kubernetes crea automáticamente otro idéntico.

### Modo 2: escalado declarativo mediante archivo YAML

El segundo método consiste en despecificar el número de réplicas directamente en el archivo YAML, dentro del campo ``spec: replicas:``. Aunque puede resultar un poco más lento que hacerlo desde la línea de comandos, tiene la ventaja de ser un método declarativo.

Eso significa que los cambios quedan reflejados en el manifiesto, por lo que persisten en el tiempo y pueden volverse a aplicar sin perder configuraciones previas.

Para escalar con este método se ha incluido el siguiente bloque de código en el manifiesto original:

````yaml
spec:
  replicas: 4 
````

![yaml](/kubernetes/datos/Ejercicio_6/ejercicio-6_1.2.png)

Como se puede observar, al volver a aplicar el manifiesto actualizado, Kubernetes ha creado automáticamente dos nuevos *Pods* para alcanzar el total de 4 réplicas indicado.

### Modo 3: escalado declarativo mediante edición en consola

El tercer y último método permite escalar un *Deployment* de forma **declarativa**, pero sin necesidad de modificar un archivo externo. En su lugar, se edita el recurso directamente desde la consola usando el comando:

````powershell
kubectl edit deploy <nombre>
kubectl edit deploy demogato-yaml
````

![yaml](/kubernetes/datos/Ejercicio_6/ejercicio-6_1.5.png)

![yaml](/kubernetes/datos/Ejercicio_6/ejercicio-6_1.3.png)

Al ejecutar el comando, se abre un editor de texto directamente en la consola, donde se puede modificar el valor del campo ``replicas:``. Al guardar los cambios, Kubernetes crea automáticamente tres nuevos *Pods* para alcanzar el total de 7 réplicas indicado.

Aunque se trata de un enfoque declarativo, los cambios solo se aplican al recurso desplegado en el clúster, pero no al archivo de configuración local. Por lo tanto, si se vuelve a aplicar el YAML original más adelante, el número de réplicas volverá al valor que tenía definido en ese archivo.

<br>

Finalmente, se procede a eliminar el *Deployment* para liberar recursos:

````powershell
kubectl delete deployment demogato-yaml
````

![Borrado](/kubernetes/datos/Ejercicio_6/ejercicio-6_1.4.png)