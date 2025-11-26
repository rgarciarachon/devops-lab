# Docker
## Ejercicio 2

### 1. Retaggea la imagen descargada en el Ejercicio 1. Respeta el formato correspondiente. Define un número de versión.

Por retaggear se entiende cambiar o agregar una nueva etiqueta a una imagen Docker existente. No obstante, hay que tener en cuenta que no se crean nuevas imágenes, sino que se le asigna una nueva etiqueta a la misma imagen, es decir, se le agrega una nueva forma de referenciarla.

Asimismo, es importante destacar que existe un formato oficial para taggear esas imágenes, con el objetivo de que Docker pueda reconocerla y gestionarla correctamente. El formato es el siguiente:

````
local-image:tagname user/new-repo:tagname
````

**IMPORTANTE**: si no indicamos el nombre de usuario y el repositorio, Docker Hub va a intepretar que intentas subir la imagen al repositorio oficial de Docker Hub y te lanzará un error por falta de permisos.

Una vez creado el repositorio donde almacenaremos la imagen, se ejecuta el siguiente comando para retaggear:

````
docker tag debian:latest rgarciarachon/debian:v1
````

![Taggear](/docker//datos/Ejercicio%202/Ejercicio-2_1.1.png)

![Resultado](/docker//datos/Ejercicio%202/Ejercicio-2_1.1.1.png)

Tal y como se puede comprobar en la imagen, el ID sigue siendo el mismo, por lo que la imagen también es la misma, solo se le ha añadido una nueva etiqueta.

### 2. Sube la imagen a tu cuenta propia en el registry de Docker.

Para subir la imagen a la cuenta, necesitamos iniciar sesión y realizar un push con el siguiente comando:

````
docker push rgarciarachon/debian:v1
````
![Subir imagen](/docker//datos/Ejercicio%202/Ejercicio-2_1.4.png)

### 3. Verificar la Imagen en Docker Hub.

Si volvemos al repositorio de Docker Hub vemos que la imagen se ha subido correctamente.

![Repositorio](/docker//datos/Ejercicio%202/Ejercicio-2_1.2.png)