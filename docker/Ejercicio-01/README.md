# Docker
## Ejercicio 1

### 1. Utilizar el comando que nos permite bajarnos una imagen para tenerla en local

Una vez instalado Docker Desktop, se requiere instalar una imagen en local para poder crear nuestro primer contenedor. Por defecto, las imágenes se descargan desde el registro Docker Hub.

````
docker pull debian
````

Mediante el comando expuesto más arriba, le estamos indicando a Docker que queremos descargar la imagen del SO Debian sin una versión específica, por lo que nos descarga la última versión.

![Imagen debian](/docker//datos/Ejercicio%201/ejercicio-1_1.1.png)

Con el comando ``docker images`` comprobamos que se ha instalado correctamente:

![Imagen debian](/docker//datos/Ejercicio%201/ejercicio-1_1.2.png)

### 2. Obtenido la imagen, desplegar el contenedor con la nomenclatura ``nombre-imagen``

````
docker run -it --name Raquel-debian debian bash
````

![Contenedor](/docker//datos/Ejercicio%201/ejercicio-1_1.3.png)

**Aviso**: al crearlo se accede automáticamente al contenedor.

Una vez descargada la imagen, podemos comenzar a desplegar nuestro primer contenedor. Para ello, se hará uso del commando ``run`` seguido de los siguientes argumentos:

- **-it**: nos permite interactuar con el contenedor mediante la terminal.
- **--name**: nos permite asignarle al contenedor un nombre personalizado.

![Contenedor](/docker//datos/Ejercicio%201/ejercicio-1_1.4.png)

### 3. Usar el comando para listar las imagenes.

Tal y como hemos visto en el apartado 1, se pueden comprobar las imágenes que hay disponibles mediante el siguiente comando:

````
docker images
````

![Imagen debian](/docker//datos/Ejercicio%201/ejercicio-1_1.2.png)

### 4. Usar el comando para listar los contenedores y su estado.

Si quisiéramos comprobar que el contenedor se ha creado correctamente, se puede hacer uso de los siguientes comandos:

````
docker ps
docker ps -a
````

- ``docker ps``: permite ver los contenedores disponibles siempre y cuando se estén utilizando.
- ``docker ps -a``: permite ver los contenedores disponibles independientemente de si se están utilizando o no.

![Contenedor](/docker//datos/Ejercicio%201/ejercicio-1_1.5.png)

En nuestro caso, nos aparece el mismo contenido en ambos comando porque tenemos el contenedor activo.

### 5. Crea en tu ordenador un fichero llamado "index.html" y copialo dentro del contenedor, con el comando correspondiente.

Se ha creado un fichero ``index.html`` en el directorio personal. Si quisiéramos copiar dicho fichero en el contenedor, deberemos utilizar el siguiente comando:

````
docker cp nombreFichero:rutaFichero nombreContenedor:rutaContenedor
````

````
docker cp index.html Raquel-debian:/root/
````

En nuestro caso, se está copiando el archivo directamente desde su ubicación, por lo que no es necesario añadir la ruta. De igual modo, se ha decidido copiar el archivo en el directorio ``/root/`` del contenedor.

![Copiar](/docker//datos/Ejercicio%201/ejercicio-1_1.6.png)

### 6. Usar el comando que os permita meteros por consola al contenedor y verificar que el archivo fue copiado con éxito. Luego, haced cualquier otro comando.

````
docker exec -it Raquel-debian bash
````

Gracias al comando expuesto arriba, se puede acceder al contenedor y comprobar si el fichero se ha copiado correctamente.

![Archivo copiado](/docker//datos/Ejercicio%201/ejercicio-1_1.7.png)

Posteriormente, se ha ejecutado el siguiente comando para obtener información sobre el sistema operativo con el que trabaja el contenedor.

````
uname -a
````

![Comando](/docker//datos/Ejercicio%201/ejercicio-1_1.8.png)

Nuestro contenedor utiliza Linux en una arquitectura de 64 bits.

### 7. Consultar los logs del contenedor, con el comando que corresponda.

Mediante el comando ``docker logs [nombreContenedor]``, se pueden consultar los logs de nuestro contenedor.

````
docker logs Raquel-debian
````

![Logs](/docker//datos/Ejercicio%201/ejercicio-1_1.9.png)

Cuando ejecutamos el comando, se pueden observar los últimos movimientos realizados en el contenedor. Esto es debido a que el contenedor está configurado para ejecutar un proceso interactivo (bash) y no un servicio o aplicación en segundo plano, como un servidor web o base de datos.

### 8. Eliminar el contenedor

Para eliminar el contenedor, haremos uso del siguiente comando:

````
docker rm Raquel-debian
````

En la siguiente imagen, se puede comprobar su correcta eliminación.

![Eliminar contenedor](/docker//datos/Ejercicio%201/ejercicio-1_1.10.png)

### 9. Eliminar la imagen de vuestro registry local

Para eliminar la imagen, primero tenemos que comprobar qué imagenes tenemos instaladas.

````
docker images
````

Posteriormente, ejecutaremos el siguiente comando:

````
docker rmi debian
````

Con ello, conseguimos eliminar la imagen del registro local. 

![Eliminar imagen](/docker//datos/Ejercicio%201/ejercicio-1_1.11.png)