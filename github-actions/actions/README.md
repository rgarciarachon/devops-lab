# Github Actions
## Actions

En Github Actions, las *actions* son unidades reutilizables de código que automatizan tareas dentro de un *workflow*.

A lo largo de estos ejercicios, se aprenderá a crear y utilizar *composite actions* y se trabajará en su correcta integración en los *workflows*.

### Ejercicio 1

En este ejercicio, se deberá crear una *action* personalizada que genere un archivo de texto en el directorio raíz del repositorio y escriba un mensaje dentro de él.

Para ello, se utilizará un **composite action**, que permite definir multiples pasos en una sola *action* reutilizable.

````yml
#Action

# Nombre de la action
name: Crear archivo de texto
# Breve descripción de su funcionamiento
description: Crea una archivo de texto en el directorio raíz del repositorio

# Datos que recoge desde el workflow
inputs:
  message:
    description: 'Mensaje'
    required: true
    # Define un valor por defecto en caso de que el workflow no pase nada
    default: 'Hola, mundo.'

# Action de tipo composite
runs:
  using: composite

  steps:
    - name: Crear archivo en directorio raíz
      shell: bash
      run: |
        echo "${{ inputs.message }}" > action1.txt

    - name: Mostrar contenido del archivo creado
      shell: bash
      run: cat action1.txt
````

**Aspectos importantes**:

- Para especificar que se trata de una *composite action*, se utiliza la clave ``using: composite``.

- Se define un ``input`` que captura el mensaje proporcionado por el usuario y lo escribe en el archivo generado.

- En las *actions* es recomendable definir la clave ``shell``, ya que especifica el entorno en el que se ejecutarán los comandos. Aunque por defecto se utiliza el *shell* preddeterminado del sistema operativo, si se utilizan comandos que no son compatibles con ese *shell*, se podría generar un error.

<br>

Una vez definida la *action*, se procede a crear el *workflow* que llamará a la *action*.

````yml
# Workflow

name: Action Archive Workflow

on:
  workflow_dispatch:
    # Se pide un mensaje al usuario
    inputs:
      message:
        description: 'Mensaje'
        required: true
        default: 'Mensaje por defecto desde el workflow.'

jobs:
  action-archive-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del código
        uses: actions/checkout@v4

      - name: Crear archivo a partir del mensaje
        uses: ./.github/actions/action_1
        with:
          message: ${{ github.event.inputs.message }}
````

**Aspectos importantes**:

- Para que el *workflow* pueda utilizar la *action*, es necesario llamarla dentro de un *step* mediante la clave ``uses``, indicando la ruta relativa a la ubicación de la *action* dentro del repositorio.

- Al invocar a la *action*, se le pasa un parámetro de entrada que transmite el mensaje ingresado por el usuario al momento de ejecutar el *workflow*.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado, creando un archivo con el mensaje introducido por el usuario.

![resultado](/github-actions//datos/Actions/ejercicio-1_1.2.png)

![resultado](/github-actions/datos/Actions/ejercicio-1_1.1.png)


### Ejercicio 2

En este ejercicio, se deberá crear una *action* personalizada que imprima el nombre del autor del último commit en los *logs* del *workflow*.

Para ello, se utilizarán comandos de Git para obtener tanto el nombre como el correo electrónico del autor, y luego se mostrarán mediante un comando ``echo``.

````yml
# Action

name: Obtener autor del último commit
description: Recupera el autor del último commit realizado en el repositorio actual

runs:
  using: composite

  steps:
    # Se obtiene la información mediante el comando git log
  - name: Obtener autor del último commit
    shell: bash
    run: |
      AUTHOR_NAME=$(git log -1 "--pretty=format:%an")
      AUTHOR_EMAIL=$(git log -1 "--pretty=format:%ae")
      
      echo "El último commit fue realizado por $AUTHOR_NAME <$AUTHOR_EMAIL>"
````

**Aspectos importantes**:

- La información se almacena en dos variables, lo que facilita su manipulación y uso posterior.

- Se utiliza ``--pretty=format`` junto con los parámetros ``%an`` (nombre del autor) y ``%ae`` (correo del autor) para personalizar la salida de ``git log``.

- Se especifica el uso de la *shell* de Bash para garantizar que los comandos se ejecuten en el entorno adecuado.

Una vez definida la *action*, se procede a crear el *workflow* que llamará a la *action*. 

````yml
# Worlflow

name: Last Author Workflow

on:
  workflow_dispatch:

jobs:
  last-author-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del código
        uses: actions/checkout@v4

      - name: Obtener autor del último commit
        uses: ./.github/actions/action_2
````

Al igual que en el ejercicio anterior, se invoca a la *action* dentro de un *step* mediante la clave ``uses``, indicando la ruta relativa a la ubicación de la *action* dentro del repositorio.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado, llamando a la *action* e imprimiendo el nombre y correo del autor del último commit.

![resultado](/github-actions//datos/Actions/ejercicio-2_1.2.png)

![resultado](/github-actions//datos/Actions/ejercicio-2_1.1.png)


### Ejercicio 3

En este ejercicio, se deberá crear un *workflow* que suba un archivo existente en el repositorio como artefacto, y luego lo descargue y muestre su contenido en una tarea posterior.

````yml
name: Artifact Workflow

on:
  workflow_dispatch:

jobs:
  upload-archive:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del código
        uses: actions/checkout@v4

      # Se almacena el archivo como artefacto para poder usarlo entre jobs
      - name: Almacenar archivo existente como artefacto
        uses: actions/upload-artifact@v4
        with:
          name: jobs1-archive
          path: jobs1.txt # Se utiliza el archivo subido en el ejercicio jobs-1

  download-archive:
    runs-on: ubuntu-latest
    needs: [upload-archive]

    steps:
      - name: Descargar el artefacto
        uses: actions/download-artifact@v4
        with:
          name: jobs1-archive

      - name: Mostrar su contenido
        run: cat jobs1.txt
````

**Aspectos importantes**:

- Para subir un archivo como artefacto, se debe utilizar la clave ``uses``, seguida del argumento ``actions/checkout@v4``.

- De manera similar, para descargar el archivo en el siguiente *job*, se debe utilizar la clave ``uses``, seguida del argumento ``actions/download-artifact@v4``.

- En este ejercicio, se han utilizado dos *actions* predefinidas de GitHub, lo que demuestra su reutilización en distintos contextos y las posibilidades que ofrecen.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Actions/ejercicio-3_1.2.png)

![resultado](/github-actions//datos/Actions/ejercicio-3_1.1.png)