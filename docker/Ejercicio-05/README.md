# Docker

## Objetivos
- Practicar el uso de RUN, CMD y Entrypoint.
- Reconocer las diferencias.

## Ejercicio 5

### RUN, CMD y ENTRYPOINT

1. Crear un Dockerfile que corra una instrucción RUN que pause la ejecución por 10 segundos. Generar la imagen y el contenedor.

````dockerfile
# Dockerfile

# Usa una imagen base de Ubuntu
FROM ubuntu:latest

# Pausa la ejecución durante 10 segundos durante la construcción de la imagen
RUN sleep 10

# Define el comando por defecto para mantener el contenedor en ejecución
CMD ["bash"]
````

A la hora de realizar el Dockerfile, se introduce el comando ``RUN`` para realizar una pausa de 10 segundos cuando inicie el contenedor.

Una vez creado el Dockerfile, se procede a la creación de la imagen.

````
docker build --no-cache -t sleep-run .
````

![resultado](/docker/datos/Ejercicio%205/ejercicio-5_1.1.png)

Tal y como se puede comprobar, la construcción de la imagen ha realizado una pausa de 10 segundos. En este caso, se ha utilizado el argumento ``--no-cache`` para evitar que Docker utilizase información previa almacenada y realizara la construcción según lo establecido.

Acto seguido, se crea el contenedor con dicha imagen.

````
docker run -d --name contenedor-run sleep-run
````

![resultado](/docker/datos/Ejercicio%205/ejercicio-5_1.2.png)

2. Modificar el Dockerfile anterior para que la pausa por 10 segundos se haga con una instrucción CMD. Generar la imagen y el contenedor.

````dockerfile
# Dockerfile

# Usa una imagen base de Ubuntu
FROM ubuntu:latest

# Pausa el contenedor durante 10 segundos
CMD ["sleep", "10"]
````

Se modifica el Dockerfile y se añade la pausa de 10 segundos mediante el comando CMD.

Se crean la imagen y el contenedor:

![resultado](/docker/datos/Ejercicio%205/ejercicio-5_1.3.png)