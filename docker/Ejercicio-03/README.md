# Docker
## Ejercicio 3

El ejercicio consta de dos proyectos por separado escritos en nodejs, uno actua de backend y el otro de fronend.

- Ejercicio-03/ui-web -> Frontend
- Ejercicio-03/api-web -> Backend

### 1. Crear los fichero dockerfile en cada proyecto

Se crean dos archivos Dockerfile, uno en cada carpeta de proyecto (front y back). En él, se ejecutan los siguientes comandos:

**DOCKERFILE BACK**

````dockerfile
# Dockerfile

# Usa una imagen base oficial
FROM node:18

# Crea un directorio de trabajo dentro del contenedor
WORKDIR /app
    
# Copia el archivo package.json 
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código fuente al contenedor
COPY . .

# Puerto en el que la api escuchará las peticiones
EXPOSE 3000

# Define el comando por defecto para ejecutar el servidor
CMD ["node", "index.js"]
````
<br>

**DOCKERFILE FRONT**

````dockerfile
# Dockerfile

# Usa una imagen base oficial
FROM node:18

# Crea un directorio de trabajo dentro del contenedor
WORKDIR /app

# Crea los directorios necesarios    
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
    
# Copia el archivo package.json 
COPY package*.json ./

# Instala las dependencias
RUN yarn install

# Copia el resto del código fuente al contenedor
COPY . .

# Puerto en el que la api escuchará las peticiones
EXPOSE 5173

# Define el comando por defecto para ejecutar el servidor
CMD ["yarn", "dev", "--host"]
````
<br>

### 2. Ejecutar los comandos necesarios para generar las imágenes. Realizar el retag de la imágenes para que sea con la siguiente nomenclatura ``<vuestro nombre>/<nombre proyecto>:0.0.1``

En primer lugar, generamos las imágenes con el comando ``docker build`` y, con el argumento ``-t``, le otorgamos un nombre inicial.

````
docker build -t api-web:latest .
````

![Build](/docker/datos/Ejercicio%203/ejercicio-3_1.1.png)

````
docker build -t ui-web:latest .
````

![Build](/docker/datos/Ejercicio%203/ejercicio-3_1.2.png)

Posteriormente, se comprueba que se han generado correctamente y le cambiamos la etiqueta a la nomenclatura correspondiente.

````
docker tag api-web:latest rgarciarachon/api-web:0.0.1
docker tag api-web:latest rgarciarachon/ui-web:0.0.1
````

![tag](/docker/datos/Ejercicio%203/ejercicio-3_1.3.png)

### 3. Desplegar 2 contenedores, uno el front y el otro el back.

Se despliegan ambos contenedores y se listan para comprobar su correcto despliege.

````
docker run -t --name back -p 5000:3000 rgarciarachon/api-web:0.0.1
docker run -t --name front -p 5173:5173 rgarciarachon/ui-web:0.0.1
````

![contenedores](/docker/datos/Ejercicio%203/ejercicio-3_1.4.png)

![Docker](/docker/datos/Ejercicio%203/ejercicio-3_1.7.png)

### 4. Usar el navegador para verificar el funcionamiento.

Cuando se consulta el back, se obtiene lo siguiente:

![back](/docker/datos/Ejercicio%203/ejercicio-3_1.5.png)

Cuando se consulta el front, se obtiene lo siguiente:

![front](/docker/datos/Ejercicio%203/ejercicio-3_1.6.png)


### 5. Eliminar los contenedores

Se eliminan los contenedores mediante la terminal.

````
docker stop front back
docker rm front back
````

![Eliminar contenedores](/docker/datos/Ejercicio%203/ejercicio-3_1.8.png)

### 6. Eliminar las imágenes

Se eliminan las imágenes mediante la terminal.

````
docker rmi ui-web api-web rgarciarachon/ui-web rgarciarachon/api-web
````

![Eliminar imagenes](/docker/datos/Ejercicio%203/ejercicio-3_1.9.png)