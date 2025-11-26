# GitHub Actions Lab

Esta carpeta contiene ejercicios prácticos de **GitHub Actions**, organizados por subtema.  
El objetivo es aprender de forma práctica cómo crear y usar workflows, acciones personalizadas, triggers, contextos, variables y workflows reutilizables.

## Objetivos
- Practicar la creación de workflows CI/CD.
- Entender cómo funcionan los triggers (`push`, `pull_request`, `schedule`, etc.).
- Aprender a crear y usar acciones personalizadas.
- Manejar contextos y variables en los workflows.
- Aprender a configurar jobs y workflows reutilizables.
- Usar secretos y variables de entorno de manera segura.

<br>

> Estos ejercicios son **de aprendizaje personal**, pero puedes usar los ejemplos para experimentar en tus propios repositorios.


## Estructura de la carpeta

````
github-actions/
├── .github/                # Carpeta opcional para workflows reales
├── actions/                # Ejercicios de Actions
│   ├── README.md
│   └── *.yml o scripts
├── context/                # Ejercicios sobre contextos
│   ├── README.md
│   └── *.yml
├── jobs/                   # Ejercicios sobre jobs
│   ├── README.md
│   └── *.yml
├── reusable/               # Ejercicios con workflows reutilizables
│   ├── README.md
│   └── *.yml
├── triggers/               # Ejercicios sobre triggers
│   ├── README.md
│   └── *.yml
├── variables/              # Ejercicios sobre variables
│   ├── README.md
│   └── *.yml
└── README.md               # README general con explicación de la carpeta
````

### Nota sobre `.github/`

- GitHub ejecuta automáticamente los archivos `.yml` dentro de `.github/workflows/`.
- Para **evitar ejecuciones no deseadas**, mantén los ejercicios en las carpetas de cada subtema en lugar de `.github/`.
- Alternativamente, puedes renombrar los archivos en `.github/` a `.disabled` o `.yml.example` si quieres conservarlos como referencia sin que se ejecuten.

## Requisitos para ejecutar los workflows

Para ejecutar los workflows de estos ejercicios se necesita un **runner de GitHub Actions**, que es el entorno donde se ejecutan los jobs.  

- GitHub ofrece runners hospedados gratuitos para repositorios públicos:
  - `ubuntu-latest`
  - `windows-latest`
  - `macos-latest`
- Cada job en un workflow indica el runner con `runs-on`. Por ejemplo:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: echo "Hola mundo"
```

## Cómo usar estos ejercicios
1. Navega a la carpeta del subtema que quieras practicar.
2. Lee el README del subtema para entender los ejercicios y objetivos.
3. Para probar un workflow, copia los archivos `.yml` a `.github/workflows/` de un repositorio de prueba.
4. Cada ejercicio es independiente y está diseñado para experimentar de manera segura.

## Licencia
Estos ejercicios están bajo la **GNU General Public License (GPL)**. Consulta el archivo [LICENSE](../LICENSE) para más detalles.