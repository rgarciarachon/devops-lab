# Docker Lab

Esta carpeta contiene una serie de ejercicios prácticos de **Docker**, organizados de forma progresiva para aprender desde la gestión de imágenes y contenedores hasta la creación de Dockerfiles y el despliegue de aplicaciones reales.

## Objetivos

- Aprender a manejar imágenes y contenedores.
- Familiarizarse con comandos esenciales de Docker.
- Crear y entender la estructura de Dockerfiles.
- Ejecutar aplicaciones reales dentro de contenedores.
- Practicar volúmenes, redes y buenas prácticas en imágenes.
- Comprender diferencias entre instrucciones `RUN`, `CMD` y otros conceptos clave.

## Estructura del directorio

````
docker/
├── Ejercicio-01/           # Gestión inicial de imágenes y contenedores
│   ├── README.md
│   └── index.html
├── Ejercicio-02/           # Retagging, versionado y subida de imágenes a Docker Hub
│   ├── README.md
├── Ejercicio-03/           # Contenerización de aplicaciones Node.js
│   ├── ui-web/             # Proyecto frontend con su Dockerfile
│   ├── api-web/            # Proyecto backend con su Dockerfile
│   ├── README.md
├── Ejercicio-04/           # Servidor NGINX con volumen compartido entre host y contenedor
│   ├── Dockerfile
│   ├── index.html
│   ├── README.md
├── Ejercicio-05/           # Comparativa RUN vs CMD con pausas de ejecución
│   ├── Dockerfile
│   ├── README.md
├── datos/                  # Imágenes y capturas de los ejercicios
└── README.md               # README general de la carpeta Docker

````

Cada carpeta contiene:
- Un **README.md** con explicación del ejercicio.
- Archivos necesarios (Dockerfile, scripts, recursos, etc.).

## Cómo usar estos ejercicios

1. Entra en la carpeta del ejercicio que quieras practicar.  
2. Lee el README asociado para ver el enunciado y objetivos.  
3. Ejecuta las prácticas en tu entorno Docker local.  
4. Modifica los Dockerfiles o pasos para experimentar y aprender más.


## Requisitos previos

- Tener instalado **Docker Desktop** o Docker Engine.  
- Conocimientos básicos de línea de comandos.  
- Node.js instalado para los ejercicios que lo requieren.


## Licencia

Todos los ejercicios están bajo la **GNU General Public License (GPL)**.  
Consulta el archivo [LICENSE](../LICENSE) para más detalles.
