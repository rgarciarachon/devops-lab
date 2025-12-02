# Kubernetes Lab

Este directorio reúne una colección de ejercicios progresivos diseñados para aprender y afianzar los conceptos esenciales de **Kubernetes**.  
A lo largo de los ejercicios se trabajan tanto comandos **imperativos** como configuraciones **declarativas**, cubriendo elementos como Pods, Deployments, Services, escalado, namespaces y gestión de recursos.

## Índice

- [Objetivos](#objetivos)
- [Estructura del directorio](#estructura-del-directorio)
    - [Ejercicio 1](Ejercicio01/)
    - [Ejercicio 2](Ejercicio02/)
    - [Ejercicio 3](Ejercicio03/)
    - [Ejercicio 4](Ejercicio04/)
    - [Ejercicio 5](Ejercicio05/)
    - [Ejercicio 6](Ejercicio06/)
    - [Ejercicio 7](Ejercicio07/)
    - [Ejercicio 8](Ejercicio08/)
    - [Ejercicio 9](Ejercicio09/)
    - [Ejercicio 10](Ejercicio10/)
- [Requisitos previos](#requisitos-previos)
- [Licencia](#licencia)

## Objetivos

- Dominar los comandos esenciales de `kubectl`.
- Comprender la diferencia entre despliegues **imperativos** y **declarativos**.
- Crear y gestionar **Pods**, **Deployments** y **Services**.
- Exponer aplicaciones mediante `port-forward` y `minikube service`.
- Escalar aplicaciones y administrar réplicas.
- Desplegar imágenes personalizadas dentro del clúster.
- Crear y gestionar **Namespaces** aislados.
- Aplicar **limitaciones de recursos**.


## Estructura del directorio

```
kubernetes/
├── datos/                  # Imágenes y capturas de los ejercicios
├── Ejercicio-01/
│   └── README.md          
├── Ejercicio-02/
│   ├── *.yml
│   └── README.md
├── Ejercicio-03/
│   ├── *.yml
│   └── README.md
├── Ejercicio-04/
│   └── README.md
├── Ejercicio-05/
│   ├── *.yml
│   └── README.md
├── Ejercicio-06/
│   └── README.md
├── Ejercicio-07/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── Ejercicio-08/
│   ├── *.yml
│   ├── *.yml
│   └── README.md
├── Ejercicio-09/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── Ejercicio-10/
│   ├── *.yml
│   ├── *.yml
│   └── README.md
└── README.md               # README general con explicación de la carpeta
````

## Requisitos previos

- Un clúster local como Minikube.
- kubectl instalado y configurado.
- Docker disponible para construir imágenes personalizadas (si el ejercicio lo requiere).

> [!NOTE]
    Las instalaciones de **Minikube** y **kubectl** se realizarán durante el primer ejercicio.

## Licencia
Estos ejercicios están bajo la **GNU General Public License (GPL)**. Consulta el archivo [LICENSE](../LICENSE) para más detalles.
