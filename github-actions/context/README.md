# Github Actions
## Context

En GitHub, un contexto es un conjunto de datos disponibles durante la ejecución de un *workflow*, que permiten acceder a información sobre el repositorio, el evento que lo activó y otros elementos del entorno. Estos datos pueden utilizarse en expresiones para personalizar y controlar el comportamiento del *workflow*.

A lo largo de los siguientes ejercicios, se aprenderá a utilizar diversos contextos disponibles en Github Actions, incluyendo los relacionados con *runners*, secretos y eventos del repositorio.

### Ejercicio 1

En este ejercicio, se deberá configurar un *workflow* que muestre información del *runner* donde se ejecuta el *job*. En concreto, se obtendrán los siguientes datos:

- Nombre del sistema operativo
- Arquitectura del sistema
- Espacio disponible en disco

<br>

````yml
name: Runner Context Workflow

on:
  workflow_dispatch:

jobs:
  runner-context-workflow:
    runs-on: ubuntu-latest
    
    # Se utilizan las variables del Runner Context
    steps:
      - name: Mostrar información del runner
        # Se almacena la información del disco en una variable, para después mostrarla
        run: | 
          DISK_SPACE=$(df -h)
          echo "Runner: ${{ runner.name }}"
          echo "Sistema operativo: ${{ runner.os }}"
          echo "Arquitectura: ${{ runner.arch }}"
          echo -e "Espacio disponible: \n$DISK_SPACE"
````

**Aspectos improtantes**:

- Para acceder a la información del entorno de ejecución, se ha utilizado el **Runner Context**, empleando variables predefinidas como ``${{ runner.name }}`` para el nombre del runner, ``${{ runner.os }}`` para el sistema operativo y ``${{ runner.arch }}`` para la arquitectura.

- El espacio en disco se ha obtenido mediante el comando ``df -h``, cuyo resultado se ha almacenado en una variable local para luego mostrarlo en los logs del *workflow*.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado, obteniendo los datos necesarios.

![resultado](/github-actions//datos/Context/ejercicio-1_1.2.png)

![resultado](/github-actions//datos/Context/ejercicio-1_1.1.png)

### Ejercicio 2

En este ejercicio, se configurará un *workflow* que utilice distintos secretos según la rama desde la que se ejecute: se usará ``PROD_API_KEY`` para simular un despliegue en producción si la rama es ``main``, y ``STAGING_API_KEY`` para el resto de ramas.

Antes de implementar el código, se crearon dos secretos en GitHub utilizando la pestaña **Secrets** del repositorio correspondiente. Esto permite almacenar y utilizar datos sensibles de manera segura, sin exponerlos en el código.

![resultado](/github-actions//datos/Context/ejercicio-2_1.1.png)

Una vez creados los secretos, se continuó con la implementación del código:

<br>

````yml
name: Fictional Deploy Workflow

on:
  workflow_dispatch:

jobs:
  deploy-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Mostrar la rama actual
        run: |
          echo "Rama actual: ${{ github.ref_name }}"

      # Se hace uso del condicional case para configurar el entorno
      - name: Configurar entorno según la rama
        run: |
          case "${{ github.ref_name }}" in

          main)
            echo "ENVIRONMENT=production" >> $GITHUB_ENV
            echo "API_KEY=${{ secrets.PROD_API_KEY }}" >> $GITHUB_ENV
            ;;
          *)
            echo "ENVIRONMENT=staging" >> $GITHUB_ENV
            echo "API_KEY=${{ secrets.STAGING_API_KEY }}" >> $GITHUB_ENV
            ;;

          esac
        
      # Se realiza el despliegue ficticio de una forma más limpia con variables
      # Payload: datos que se envían en el cuerpo de la petición
      - name: Realizar el despliegue
        run: |
          echo "Desplegando en el entorno ${{ env.ENVIRONMENT }}..."
          echo "Usando ${{ env.API_KEY }}..."
          echo "POST a https://fictional_deploy.com (simulado)"
          echo "Payload: {\"environment\": \"${{ env.ENVIRONMENT }}\", \"version\": \"latest\"}"        
          echo "El despliegue se ha realizado correctamente."
````

**Aspectos importantes**:

- El nombre de la rama actual se obtiene mediante el contexto de GitHub (``${{ github.ref_name }}``), lo que permite identificar en qué rama se está ejecutando el *workflow* y tomar decisiones basadas en esa información.

- Se emplea un condicional **case** para configurar dos entornos de despliegue distintos según la rama, lo que permite adaptar el flujo de trabajo a diferentes entornos sin necesidad de duplicar pasos.

- Se accede a los secretos a través del **Secret Context** y se almacena la información en variables de entorno, lo que asegura que los valores sensibles no se expongan directamente en el código y sean accesibles en pasos posteriores dentro del *workflow*.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según los esperado,  realizando el despliegue según la rama desde la que se inició.

![resultado](/github-actions//datos/Context/ejercicio-2_1.3.png)

![resultado](/github-actions//datos/Context/ejercicio-2_1.4.png)

### Ejercicio 3

En este ejercicio, se deberá configurar un *workflow* que ejecute una tarea ficticia y luego envíe un mensaje de notificación a una URL, incluyendo el estado del job y el nombre del evento que lo activó.


````yml
name: Status Workflow

on:
  workflow_dispatch:

jobs:
  status-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Realizar tarea ficticia
        run: |
          echo "Realizando tarea ficticia..."
          echo "La tarea ficticia se ha realizado con éxito."

      - name: Verificar el estado del job y enviar notificación
        if: ${{ always() }}
        run: |
          EVENT=${{ github.event_name }}
          STATUS=${{ job.status }}
          MESSAGE=""

          case $STATUS in
            success)
              MESSAGE="El job del evento '$EVENT' se completó con éxito."
              ;;
            failure)
              MESSAGE="El job del evento '$EVENT' falló."
              ;;
            cancelled)
              MESSAGE="El job del evento '$EVENT' se canceló."
              ;;
            *)
              MESSAGE="El job del evento '$EVENT' terminó con estado desconocido: $STATUS."
              ;;
          esac

          echo "Enviando notificación..."
          echo "POST a https://fictional_notification.com (simulado)"
          echo "Payload: {
            \"event\": \"$EVENT\", 
            \"status\": \"$STATUS\",
            \"message\": \"$MESSAGE\"}"
````

**Aspectos importantes**:

- Se utiliza el contexto ``${{ job.status }}`` para obtener el estado del *job*, lo cual es esencial para determinar el comportamiento de la notificación.

- El mensaje se configura mediante un bloque **case**, que personaliza el contenido según el estado del *job*. Se contemplan todos los posibles valores de la variable ``status`` de dicho contexto.

- Se utiliza el condicional ``if: ${{ always() }}`` para garantizar que la notificación se envíe sin importar el estado del *job*, asegurando que el paso de notificación se ejecute tanto en caso de éxito como de fallo.

Como se puede observar, el archivo se subió correctamente y el *workflow* se ha ejecutado según lo esperado, capturando el estado del *job* y lanzando el mensaje definido para ese caso.

![resultado](/github-actions//datos/Context/ejercicio-3_1.2.png)

![resultado](/github-actions//datos/Context/ejercicio-3_1.1.png)


### Ejercicio 4

En este ejercicio, se deberá configurar un *workflow* que se active al abrir una ``pull request``. El flujo de trabajo deberá verificar si el título de la *pull request* incluye una palabra clave específica ``urgent``. Si se encuentra la palabra en el título, se imprimirá el título y el cuerpo de la PR; si no se encuentra, la ejecución del *workflow* debe fallar.

<br>

````yml
name: Keyword Workflow

on:
  pull_request:
    types: [opened]

jobs:
  keyword-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del código
        uses: actions/checkout@v4

      - name: Capturar título y cuerpo de la pull request
        run: |
          TITLE="${{ github.event.pull_request.title }}"
          echo "TITLE=$TITLE" >> $GITHUB_ENV
          TITLE_LOWER=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]')
          echo "TITLE_LOWER=$TITLE_LOWER" >> $GITHUB_ENV
          echo "BODY=${{ github.event.pull_request.body }}" >> $GITHUB_ENV
        
      - name: Definir palabra clave
        run: |
          echo KEYWORD="urgent" >> $GITHUB_ENV

      - name: Ejecutar si contiene palabra clave
        if: ${{ contains(env.TITLE_LOWER, env.KEYWORD) }}
        run: |
          echo "El título contiene la palabra 'urgent'."
          echo "Título de la Pull Request: ${{ env.TITLE }}"
          echo "Cuerpo de la Pull Request: ${{ env.BODY }}"

      - name: Ejecutar si no contiene palabra clave
        if: ${{ !contains(env.TITLE_LOWER, env.KEYWORD) }}
        run: |
          echo "El título no contiene la palabra 'urgent'"
          exit 1 
````

**Aspectos importantes**:

- Se accede al título y al cuerpo de la *pull request* mediante el contexto de Github, utilizando ``${{ github.event.pull_request.title }}`` y ``${{ github.event.pull_request.body }}`` respectivamente.

- El título se convierte a minúsculas para realizar una comparación insensible a mayúsculas y minúsculas al buscar la palabra clave.

- Se utilizan variables de entorno para almacenar y reutilizar información, como el título, el cuerpo y la palabra clave, a lo largo de las diferentes etapas del *workflow*.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

Primero se verificó un caso en el que el título contenía la palabra clave, y luego otro en el que dicha palabra no estaba presente.

![resultado](/github-actions//datos/Context/ejercicio-4_1.1.png)

![resultado](/github-actions//datos/Context/ejercicio-4_1.2.png)