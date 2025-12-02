# GitHub Actions
## Triggers

GitHub Actions es una herramienta integrada en GitHub que permite automatizar tareas directamente dentro del repositorio.

En este apartado, se aprenderá cómo, mediante archivos de configuración en formato YAML, es posible establecer cuándo y cómo ejecutar tareas en respuesta a eventos ocurridos dentro del repositorio.

**Importante**: los *workflows* se almacenarán en la carpeta ``.github/workflows/`` del repositorio.

### Ejercicio 1

En este ejercicio, se deberá configurar un *workflow* para que se ejecute automáticamente cuando se abra un Pull Request en el repositorio.

Para hacerlo, se debe crear un archivo de configuración que incluya lo siguiente:

- ``name``: es el nombre que se le asigna al *workflow*. Este nombre es descriptivo y solo se muestra en la interfaz de GitHub.

- ``on``: define el evento que activará el *workflow*.

- ``types``: especifica con más precisión qué tipo de acción sobre un evento debe activar el *workflow*.

- ``branches``: especifica las ramas en las que se debe ejecutar el flujo de trabajo.

- ``jobs``: son las tareas que el *workflow* ejecutará. Un *workflow* puede contener uno o más *jobs*.

- ``steps``: son los pasos que conforman cada *job*. Se ejecutan de manera secuencial.

En este caso, se utilizará la clave ``on`` para indicar que el *workflow* debe ejecutarse cuando ocurra el evento ``pull_request``, específicamente cuando se abra o se vuelva a abrir un Pull Request.

````yml
name: Pull Request Workflow # Nombre del workflow

on:
  pull_request: # Desencadenante
    types: [opened, reopened] # Tipos de pull request
    branches: # Ramas en las que se aplicará el workflow
      - main
      - RaquelGarciaExercises
    
jobs:
  pull-request-workflow: # Nombre del job
    runs-on: ubuntu-latest # Entorno de ejecución

    steps: # Tareas
      - name: Imprimir mensaje
        run: echo "Mi primer workflow"
````

Para comprobar su funcionamiento, es necesario subir el archivo de configuración a la rama ``main`` y luego realizar el evento correspondiente, es decir, abrir o reabrir un Pull Request. Una vez hecho esto, se puede acceder a la pestaña **Actions** en GitHub para visualizar los *workflows* que se han ejecutado.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Triggers/ejercicio-1_1.1.png)

![resultado](/github-actions//datos/Triggers/ejercicio-1_1.2.png)


### Ejercicio 2

En este ejercicio, se deberá configurar un *workflow* para que se ejecute automáticamente cuando se haga un ``push`` en la rama ``develop`` e imprima un mensaje en consola.

Al igual que en el ejercicio anterior, se utilizará la clave ``on`` para indicar que el *workflow* debe ejecutarse cuando ocurra el evento ``push``. Además, se indicará la rama sobre la cual debe activarse el flujo de trabajo, utilizando la clave ``branches``.

**Importante**: para hacer este ejercicio, se ha optado por utilizar la rama de trabajo actual en lugar de crear una nueva rama ``develop``.

````yml
name: Push Workflow

on:
  push:
    branches: # Se ejecutará únicamente en la rama indicada
      - RaquelGarciaExercises

jobs:
  push-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir mensaje
        run: echo "Hello, World!" 
````

Para poder comprobar su funcionamiento, se ha realizado un ``push`` de los archivos al repositorio.

Como resultado, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Triggers/ejercicio-2_1.2.png)


![resultado](/github-actions//datos/Triggers/ejercicio-2_1.1.png)

### Ejercicio 3

En este ejercicio, se deberá configurar un *workflow* para que se ejecute automáticamente cuando se cree una nueva ``issue``.

Para ello, se utilizará la clave ``on`` para definir el evento ``issues``, y se especificará mediante la clave ``types`` que el flujo de trabajo solo se active cuando se abra una nueva ``issue``.

````yml
name: Issues Workflow

on:
  issues:
    types: [opened] # Se ejecuta únicamente cuando se crea una nueva issue

jobs:
  issues-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir mensaje
        run: echo "Se ha creado una nueva issue."
````

Para poder comprobar su funcionamiento, se ha creado una nueva **issue** en el apartado ``Issues`` de Github.

Como resultado, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Triggers/ejercicio-3_1.1.png)

![resultado](/github-actions//datos/Triggers/ejercicio-3_1.2.png)


### Ejercicio 4

En este ejercicio, se deberá configurar un *workflow* para que se ejecute automáticamente todos los días a las 12 h y que imprima un mensaje en consola.

Para ello, se utilizará la clave ``on`` para definir el evento ``schedule``, y se especificará mediante la clave ``cron`` la expresión de tiempo según el formato estándar oficial.

``Schedule`` nos permite programar la ejecución de los flujos de trabajo.

**Importante:**

La clave ``cron`` presenta cinco campos:

| Campo        | Descripción                                          |
|--------------|------------------------------------------------------|
| `Minuto`     | Minuto en que se ejecuta el trabajo (0-59).       |
| `Hora`       | Hora en que se ejecuta el trabajo (0-23).         |
| `Día del mes`| Día del mes en que se ejecuta el trabajo (1-31).  |
| `Mes`        | Mes en que se ejecuta el trabajo (1-12).          |
| `Día de la semana` | Día de la semana en que se ejecuta el trabajo (0-6, donde 0 es domingo). |

<br>

````yml
name: Schedule Workflow

on:
  schedule:
     - cron: '0 12 * * *'  # Se ejecuta todos los días a las 12:00 UTC

jobs:
  schedule-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir mensaje
        run: echo "Scheduled job executed!"
````

En este caso, se ha establecido que el minuto sea 0 y el campo de hora sea 12. Al dejar los demás campos con un ``*``, se indica que el *workflow* debe ejecutarse todos los días a las 12:00, sin importar el día del mes, el mes o el día de la semana.

Para poder comprobar su funcionamiento, se tuvo que esperar a la hora indicada.

![resultado](/github-actions//datos/Triggers/ejercicio-7_1.1.png)

![resultado](/github-actions//datos/Triggers/ejercicio-7_1.2.png)


## Dispatch

En este apartado, se aprenderá a configurar y utilizar el trigger ``workflow_dispatch`` que, a diferencia de otros triggers que se activan automáticamente, permite ejecutar un *workflow* de manera manual.

### Ejercicio 1

En este ejercicio, se deberá configurar un *workflow* que se ejecute manualmente y que imprima en consola un mensaje proporcionado por el usuario como parámetro.

Para ello, se utilizará el trigger ``workflow_dispatch``, que permite definir entradas personalizadas a través de la clave ``inputs``. Estas entradas pueden incluir una descripción, un valor por defecto y una indicación de si son obligatorias.

En este caso, se ha definido un ``input`` denominado ``message``, que se utiliza dentro del workflow mediante la expresión ``${{ github.event.inputs.message }}`` para obtener el mensaje proporcionado por el usuario al ejecutar el *workflow* desde la interfaz de Github.

````yml
name: Message Workflow

on:
  workflow_dispatch:
    inputs: # Define un campo de entrada
      message: # Nombre del input
        description: 'Introduzca un mensaje' # Etiqueta informativa
        required: true # El campo es obligatorio
        default: 'Soy un mensaje predeterminado.' # Mensaje por defecto

jobs:
  message-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir mensaje del usuario
        run: echo "${{ github.event.inputs.message }}"
````

Como se puede observar, el *worflow* se ha ejecutado correctamente, muestra el mensaje predeterminado definido en el archivo e imprime el mensaje proporcionado a la hora de ejecutarlo manualmente.

![resultado](/github-actions//datos/Triggers/ejercicio-4_1.3.png)

![resultado](/github-actions//datos/Triggers/ejercicio-4_1.1.png)

![resultado](/github-actions//datos/Triggers/ejercicio-4_1.2.png)

### Ejercicio 2

En este ejercicio, se deberá configurar un *workflow* que se ejecute manualmente y que permita al usuario elegir entre dos entornos e imprima en consola el entorno seleccionado.

Para ello, se definirá un ``input`` de tipo ``choice``, que permite al usuario seleccionar una opción de una lista predefinida.

Posteriormente, se llamará al *input* mediante la siguiente expresión ``${{ github.event.inputs.environment }}`` para obtener el entorno seleccionado por el usuario.

````yml
name: Environment Workflow

on:
  workflow_dispatch: # Permite ejecutar el workflow manualmente
    inputs:
      environment:
        description: "Seleccione el entorno"
        type: choice # Entrada de selección
        required: true
        options: # Lista de opciones disponibles
          - production
          - staging

jobs:
  env-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir el entorno seleccionado
        run: | # Se indica que el siguiente bloque es un script multilínea
          echo "Entorno seleccionado: ${{ github.event.inputs.environment }}"
````

**Detalles relevantes**:

- Cuando se utilizan caracteres especiales, como los dos puntos (``:``) o comillas (``""``) en un ``echo``, YAML puede llegar a malinterpretar su uso. Para evitarlo, una solución eficaz puede ser usar ``|``, ya que convierte todo lo que le sigue en un bloque de texto literal.

  Asimismo, se usa para ejecutar más de un comando en un mismo ``run``.

Como se puede observar, el *workflow* se ha ejecutado correctamente, muestra la lista de ocpiones disponibles e imprime el entorno seleccionado por el usuario a la hora de ejecutarlo manualmente.

![resultado](/github-actions//datos/Triggers/ejercicio-5_1.3.png)

![resultado](/github-actions//datos/Triggers/ejercicio-5_1.1.png)

![resultado](/github-actions//datos/Triggers/ejercicio-5_1.2.png)


### Ejercicio 3

En este ejercicio, se configurará un *workflow* que se ejecute manualmente mediante el evento ``workflow_dispatch``, permitiendo al usuario seleccionar entre dos opciones y mostrando en consola un mensaje según la opción elegida.

Para ello, se definirá un ``input`` de tipo ``choice`` denominado ``confirm``, que ofrecerá al usuario las opciones ``true`` y ``false``. En función de la selección, se ejecutará únicamente el ``step`` correspondiente utilizando la condición ``if``, mientras que el otro se ignorará. Esto permite adaptar el comportamiento del *workflow* en función de la entrada proporcionada al momento de su ejecución.

````yml
name: Confirm Workflow

on:
  workflow_dispatch:
    inputs:
      confirm:
        description: Seleccione una opción
        required: true
        type: choice
        options:
          - "true"
          - "false"

        default: "false"

jobs:
  confirm-workflow:
    runs-on: ubuntu-latest

    steps: # Se controla el flujo del mensaje mediante un if
      - name: Confirmación positiva
        if: ${{ github.event.inputs.confirm == 'true' }}
        run: echo "¡Solicitud aprobada!"

      - name: Confirmación negativa
        if: ${{ github.event.inputs.confirm == 'false' }}
        run: echo "Solicitud cancelada"
````
Como se puede observar, el *workflow* se ha ejecutado correctamente, muestra la lista de opciones disponibles e imprime el mensaje correspondiente a la opción seleccionada por el usuario a la hora de ejecutarlo manualmente.

![resultado](/github-actions//datos/Triggers/ejercicio-6_1.3.png)

![resultado](/github-actions//datos/Triggers/ejercicio-6_1.1.png)

![resultado](/github-actions//datos/Triggers/ejercicio-6_1.2.png)