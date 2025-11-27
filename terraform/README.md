# Terraform Lab

Este directorio contiene una serie de ejercicios organizados de forma progresiva cuyo propósito es recorrer los fundamentos y los elementos esenciales del uso de **Terraform** como herramienta de *Infraestructura como Código (IaC)*.  
Los ejercicios abarcan desde la configuración inicial del proveedor y el uso de un Service Principal, hasta la parametrización avanzada, validación de variables y utilización de módulos locales y remotos.

## Objetivos

- Configurar el proveedor de Azure y autenticación con Service Principal.  
- Parametrizar módulos y usar variables.  
- Aplicar funciones y validar variables.  
- Implementar y usar módulos locales y remotos.  
- Mantener convenciones mediante tags.

## Estructura del directorio

````
terraform/
├── datos/                  # Imágenes y capturas de los ejercicios
├── ejercicio_1/
│   └── README.md
├── ejercicio_2/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── ejercicio_3/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── ejercicio_4/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── ejercicio_5/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── ejercicio_6/
│   ├── ficheros/           # Archivos adicionales necesarios para el ejercicio
│   └── README.md
├── .gitignore
└── README.md               # README general del módulo
````

## Requisitos generales

Dependiendo del ejercicio, pueden requerirse uno o varios de los siguientes elementos:

- Subscripción de Azure.  
- Azure KeyVault.  
- Service Principal.  
- Resource Group existente en Azure.  

> [!NOTE]
    Cada ejercicio detalla sus propios requisitos previos de forma individual.

## Licencia
Estos ejercicios están bajo la **GNU General Public License (GPL)**. Consulta el archivo [LICENSE](../LICENSE) para más detalles.