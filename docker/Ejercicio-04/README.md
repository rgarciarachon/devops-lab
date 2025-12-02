# Docker

## Objetivo

El objetivo de este ejercicio es aprender a utilizar Docker para crear un contenedor que sirva archivos web mediante NGINX, explorando la gestión de volúmenes para permitir la sincronización de archivos entre el sistema host y el contenedor, de modo que los cambios realizados en el archivo index.html se reflejen automáticamente en el servidor web sin necesidad de reiniciar el contenedor.

## Ejercicio 4

### 1. Crea un Dockerfile que use una imagen base de NGINX para crear un contenedor que sirva archivos web.

````dockerfile
# Dockerfile

# Usa una imagen base oficial
FROM nginx:stable

# Copia el archivo html al directorio de contenido web por defecto de Nginx
COPY index.html /usr/share/nginx/html/index.html

# Se indica el puerto
EXPOSE 80
````
<br>

**Aspectos interesantes**:
- NGINX no necesita el comando CMD, puesto que la imagen oficial ya tiene configurado un comando por defecto que ejecuta NGINX al iniciar el contenedor.
- No necesitamos crear un directorio de trabajo con WORKDIR, ya que solo se va a copiar un archivo al contenedor. Para ello, se utilizará el directorio por defecto de NGINX.

Una vez creado el Dockerfile, se procede a crear el archivo ``index.html`` en la misma ubicación en la que se encuentra dicho Dockerfile.

### 2. Crea un volumen que consiga vincular la máquina local con el contenedor y realiza cambios en ambos sentidos para comprobar si se reflejan.

Para vincular nuestra máquina local con el contenedor, se requiere el uso de volúmenes. En este caso, vincularemos el directorio local con el directorio del contenedor, para así, conseguir reflejar los cambios.

````
docker run -t -v [ruta-local]:[ruta-contenedor] -p 8080:80 --name [nombre-contenedor] [imagen]
````

![contenedor](/docker/datos/Ejercicio%204/ejercicio-4_1.4.png)

- Mediante el argumento ``-v``, enlazamos el directorio de la máquina local con el contenedor.

Resultado original:

![original](/docker/datos/Ejercicio%204/ejercicio-4_1.3.png)

**MODIFICACIONES**

**CONTENEDOR > LOCAL**

Primero, realizamos una modificación en el archivo dentro del contenedor gracias al comando ``nano``.

![contenedor](/docker/datos/Ejercicio%204/ejercicio-4_1.7.png)

Verificamos el archivo en local y vemos que se ha reflejado el cambio correctamente.

![local](/docker/datos/Ejercicio%204/ejercicio-4_1.8.png)

**LOCAL > CONTENEDOR**

A continuación, se procede a hacer la modificación desde el archivo local.

![local](/docker/datos/Ejercicio%204/ejercicio-4_1.9.png)

Tal y como se puede observar, el cambio se ve reflejado en el contenedor.

![contenedor](/docker/datos/Ejercicio%204/ejercicio-4_1.10.png)