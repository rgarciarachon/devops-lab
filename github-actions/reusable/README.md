# GitHub Actions
## Reusables

Los *workflows* reutilizable en GitHub Actions permiten definir un flujo de trabajo una sola vez y utilizarlo desde otros repositorios o *workflows*. Esto permite centralizar la lógica común y reducir la duplicación de código en múltiples proyectos.

A lo largo de estos ejercicios, se verá cómo definir un *workflow* reutilizable y cómo invocarlos desde otros *workflows*.

### Ejercicio 1

En este ejercicio, se definirá un *workflow* reutilizable cuya función será imprimir un mensaje. A continuación, se creará un *workflow* principal encargado de invocar y ejecutar dicho *workflow* reutilizable.

<br>

````yml
# Workflow reutilizable

name: Print Reusable Workflow

on:
  # Se establece el reusable workflow
  workflow_call:
    # Se declaran los parámetros de entrada
    inputs:
      message:
        description: "Mensaje"
        required: true
        type: string
        default: "Mensaje predeterminado."

jobs:
  print-message:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir mensaje
        run: echo "${{ inputs.message }}"
````

**Aspectos importantes**:

- Para declarar un *workflow* como reutilizable, se debe usar la clave ``workflow_call:``.

<br>

````yml
# Workflow principal

name: Print Workflow

on:
  workflow_dispatch:

jobs:
  message-reusable-workflow:
    # Se llama al workflow reutilizable
    uses: ./.github/workflows/reusable-1.yml
    # Se pasa el mensaje como parámetro
    with:
      message: "¡Hola desde el workflow reutilizable!"
````

**Aspectos importantes**:

- Para invocar el *workflow* reutilizable, se utiliza la clave ``uses:``, especificando a continuacion la ruta relativa al archivo del *workflow* dentro del repositorio.

- Se le proporciona al *reusable workflow* un parámetro de entrada que contiene el mensaje que se desea mostrar en la consola.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Reusables/ejercicio-1_1.2.png)

![resultado](/github-actions//datos/Reusables/ejercicio-1_1.1.png)


### Ejercicio 2

En este ejercicio, se configurará un *workflow* reutilizable que primero valide si el nombre de la rama desde la que se ejecuta comienza con ``feature/``. Solo en caso de que la validación sea positiva, se procederá con la tarea principal.

Para ello, se creó una nueva rama (``feature``) con el objetivo de verificar posteriormente el comportamiento y los resultados del flujo de trabajo definido.

````bash
git branch feature
````

Posteriormente, se comenzó a elaborar los distintos *workflows*:

<br>

````yml
# Workflow reutilizable

name: Validate Branch Reusable Workflow

on:
  workflow_call:

jobs:
  validate-branch-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Obtener nombre de la rama
        id: branch-name
        run: |
          echo "Rama actual: ${{ github.ref_name }}"
      
      - name: Rama válida
        if: ${{ github.ref_name == 'feature' }}
        run: echo "La rama es válida. La tarea se ha realizado correctamente."

      - name: Rama no válida
        if: ${{ github.ref_name != 'feature' }}
        run: |
          echo "La rama no es válida."
          echo "Estás en la rama ${{ github.ref_name }}."
          exit 1
````

**Aspectos importantes**:

- Se usa el contexto de Github (``github.ref_name``) para obtener el nombre de la rama desde la que se ejecuta el *workflow* y se comprueba su validez mediante el condicional ``if``.

<br>

````yml
# Workflow principal

name: Validate Branch Workflow

on:
  workflow_dispatch:

jobs:
  validate-branch-workflow:
    uses: ./.github/workflows/reusable-2.yml
````

**Aspectos importantes**:

- Para invocar el *workflow* reutilizable, se utiliza la clave ``uses:``, especificando a continuacion la ruta relativa al archivo del *workflow* dentro del repositorio.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

Primero se realiza la comprobación ejecutando el *workflow* desde la rama ``feature``, y posteriormente desde una rama distinta para verificar que el sistema de validación y error funciona correctamente.

![resultado](/github-actions//datos/Reusables/ejercicio-2_1.1.png)

![resultado](/github-actions//datos/Reusables/ejercicio-2_1.2.png)

### Ejercicio 3

En este ejercicio, se configurará un *workflow* reutilizable (``deploy-environment.yml``) para realizar despliegues en entornos específicos (``development``, ``staging``, ``production``). Este *workflow* será invocado por otro *workflow* (``trigger-deploy.yml``), el cual se ejecutará automáticamente según la rama que realice ``push`` o de manera manual.

Cada entorno tendrá variables de entorno y secretos configurados en GitHub, que se utilizarán en el *workflow* correspondiente.

**Pasos**:

- **Configurar Environments en GitHub**:
  
  Crear tres entornos (``development``, ``staging``, ``production``) en el repositorio público y configurar variables de entorno específicas como ``API_URL`` y ``LOG_LEVEL``.

- **Definir el *workflow* reutilizable**:

  Crear ``deploy-environment.yml`` que reciba un ``input`` llamado ``environment`` para determinar el entorno de despliegue.

- **Definir el *workflow* que invoca el reutilizable**:

  Crear ``trigger-deploy.yml``, que se activará en ramas específicas (``main``, ``develop``, ``release/*``) y llamará al *workflow* reutilizable para desplegar en el entorno adecuado.

<br>

````yml
# Workflow reutilizable

name: Reusable Workflow

on:
  workflow_call:
    inputs:
      environment:
        description: Seleccione el entorno (development, staging, production)
        required: true
        type: string
        
jobs:
  deploy:
    runs-on: ubuntu-latest
    # Se cargan las variables de entorno
    environment: ${{ inputs.environment }}

    steps:
    - name: Checkout del código
      uses: actions/checkout@v4
    
    - name: Validar input
      run: |
        ENV="${{ inputs.environment }}"

        if [ "$ENV" != "development" && "$ENV" != "staging" && "$ENV" != "production" ]; then
          echo "El environment no es válido."
          exit 1
        fi

    - name: Simular despliegue
      run: |
        echo "Desplegando en el entorno ${{ inputs.environment }}..."
        echo "API_URL = ${{ vars.API_URL }}"
        echo "LOG_LEVEL = ${{ vars.LOG_LEVEL }}"
        echo "Subiendo archivos..."
        sleep 2
        echo "El despliegue se ha realizado con éxito."
````

**Aspectos importantes**:

- Se define un parámetro de entrada que permite seleccionar entre los entornos ``development``, ``staging`` o ``production``.

- Se comprueba la validez del entorno seleccionado, ya que los ``inputs`` del *workflow* reutilizable no permiten listas de opciones. Por ello, se comprueba que el parámetro sea válido, especialmente si el *workflow* principal permite entradas por parte del usuario (no es nuestro caso).

- Se usa un entorno dinámico, lo que permite ejecutar el *workflow* en el entorno correspondiente sin necesidad de duplicar el código para cada uno.

- Las variables de entorno se cargan usando la clave ``environment:``, lo que facilita su acceso a través del contexto ``vars``.

<br>

````yml
# Workflow principal

name: Main Workflow

on:
  workflow_dispatch:
    inputs:
      environment:
        description: Seleccione el entorno
        required: true
        type: choice
        options:
          - development
          - staging
          - production

jobs:
  environment-workflow:
    uses: ./.github/workflows/deploy-environment.yml
    with:
      environment: ${{ inputs.environment }}
````

**Aspectos importantes**:

- Para invocar el *workflow* reutilizable, se utiliza la clave ``uses:``, especificando a continuacion la ruta relativa al archivo del *workflow* dentro del repositorio.

- Se le proporciona al *reusable workflow* un parámetro de entrada que contiene el entorno seleccionado por el usuario.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Reusables/ejercicio-3_1.4.png)

Entorno ``development``:

![resultado](/github-actions//datos/Reusables/ejercicio-3_1.1.png)

Entorno ``staging``:

![resultado](/github-actions//datos/Reusables/ejercicio-3_1.2.png)

Entorno ``production``:

![resultado](/github-actions//datos/Reusables/ejercicio-3_1.3.png)