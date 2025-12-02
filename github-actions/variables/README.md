# GitHub Actions
## Variables

En GitHub Actions, las variables permiten almacenar y reutilizar valores a lo largo de la ejecución de un *workflow*. Estas variables pueden ser definidas por el usuario, proporcionadas por el entorno (como los contextos), o generadas dinámicamente durante la ejecución.

A lo largo de los siguientes ejercicios, se abordará el uso de variables, su acceso y su aplicación en diferentes niveles del *workflow*.

### Ejercicio 1

En este ejercicio, se configurará un *workflow* compuesto por un único *job* que realiza las siguientes tareas:

- En el primer *step*, se establecerán dos variables de entorno.

- En el segundo *step*, se utilizarán dichas variables para ejecutar un comando o *script* determinado.

<br>

````yml
name: Evironment Workflow

on:
  workflow_dispatch:

jobs:
  environment-workflow:
    runs-on: ubuntu-latest

    steps:
        # Se declaran las variables de entorno en un archivo especial para poder utilizarlas entre steps
      - name: Declarar variables de entorno
        run: |
          echo "Declarando variables de entorno..."
          echo "USERNAME=Raquel" >> $GITHUB_ENV
          echo "AGE=29" >> $GITHUB_ENV

      - name: Felicitar el cumpleaños
        run: echo "¡Felicidades, ${{ env.USERNAME }}! Ya tienes ${{ env.AGE }} años."
````

**Aspectos importantes**:

- Se utiliza el archivo especial ``$GITHUB_ENV`` para definir variables de entorno, lo que permite que estas estén disponibles entre distintos *steps* dentro del mismo *job*.

- No se empleó el bloque ``env:`` porque, para que las variables fueran accesibles entre *steps*, deberían haberse definido a nivel de *job*. En este caso, siguiendo los requisitos del ejercicio, se optó por utilizar el archivo especial.

  Resultado de utilizar el bloque ``env:`` a nivel de *step*:

  ![resultado](/github-actions//datos/Variables/ejercicio-1_1.1.png)

- Las variables se recuperan mediante el contexto ``${{ env.VARIABLE }}``.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Variables/ejercicio-1_1.3.png)

![resultado](/github-actions//datos/Variables/ejercicio-1_1.2.png)


### Ejercicio 2

En este ejercicio, se configurará un *workflow* que utilice un secreto previamente definido en el repositorio para ejecutarlo dentro de un comando.

Para ello, se plantean dos escenarios en los que se utilizan dos tipos de variables proporcionadas por GitHub: variables de entorno y variables de contexto.

<br>

````yml
name: Secret Variable Workflow

on:
  workflow_dispatch:

jobs:
  secret-variable-workflow:
    runs-on: ubuntu-latest
    # Se crea la variable de entorno a nivel de job
    env:
      MY_SECRET: ${{ secrets.MY_SECRET }}

    steps:
      - name: Usar variable secreta directamente
        run: |
          echo "Usando variable secreta directamente..."
          echo "La variable es: ${{ secrets.MY_SECRET }}"

      - name: Usar variable secreta mediante variable de entorno
        run: |
          echo "Usando variable secreta mediante variable de entorno..."
          echo "La variable es: $MY_SECRET"
````

**Aspectos importantes**:

- Para acceder a la variable de entorno desde un *step*, se debe declarar a nivel de *job* utilizando la clave ``env:``.

- Para acceder directamente al valor del secreto, se utiliza el **Secret Context**, declarando el secreto de forma directa en el *workflow*.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado, recuperando la variable secreta en cada uno de los escenarios planteados.

![resultado](/github-actions//datos/Variables/ejercicio-2_1.2.png)

![resultado](/github-actions//datos/Variables/ejercicio-2_1.1.png)

### Ejercicio 3

En este ejercicio, se configurará un *workflow* que genere un número aleatorio entre 1 y 100 y ejecute un comando solo si el número generado es mayor a 50.

Para ello, se ha optado por utilizar los ``outputs``, ya que se está trabajando con un valor específico y temporal y solo se necesita pasar el valor entre *steps*.

En cambio, pese a que su uso daría resultado, no se han utilizado las **variables de entorno** porque están destinadas a almacenar valores constantes que deben de estar disponibles a lo largo de todo el *job* o incluso de un *workflow*, lo cual no era necesario en este ejercicio.

<br>

````yml
name: Step Output Workflow

on:
  workflow_dispatch:

jobs:
  random-number:
    runs-on: ubuntu-latest

    steps:
      - name: Generar número aleatorio del 1 a 100
        id: generate_number
        run: echo "RANDOM_NUMBER=$(( (RANDOM % 100) + 1))" >> $GITHUB_OUTPUT

      - name: Ejecutar si el número es mayor que 50
        # Para poder comparar valores mayores o menores hay que convertir el valor a su tipo real
        if: ${{ fromJSON(steps.generate_number.outputs.RANDOM_NUMBER) > 50 }}
        run: |
          NUMBER=${{ steps.generate_number.outputs.RANDOM_NUMBER }}
          echo "El número aleatorio es $NUMBER y es mayor que 50."

      - name: Ejecutar si el número es menor o igual que 50
        if: ${{ fromJSON(steps.generate_number.outputs.RANDOM_NUMBER) <= 50 }}
        run: |
          NUMBER=${{ steps.generate_number.outputs.RANDOM_NUMBER }}
          echo "El número aleatorio es $NUMBER y es menor que 50."
          exit 1
````

**Aspectos importantes**:

- Para generar un número aleatorio entre 1 y 100, se utiliza la expresión bash ``RANDOM % 100``, que devuelve un valor entre 0 y 99. Para ajustar el rango y empezar desde 1, se le suma 1 al resultado.

- La expresión condicional ``if`` en GitHub Actions compara valores como ``Strings`` por defecto, por lo que es necesario convertirlos a su tipo numérico real usando ``fromJSON()`` si se quiere realizar comparaciones númericas como en este caso.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

Primero se generó un número inferior a 50, lo que provocó un error intencionado, y, posteriormente, generó un número superior a 50, permitiendo la ejecución del comando.

![resultado](/github-actions//datos/Variables/ejercicio-3_1.3.png)

![resultado](/github-actions//datos/Variables/ejercicio-3_1.1.png)

![resultado](/github-actions//datos/Variables/ejercicio-3_1.2.png)

### Ejercicio 4

En este ejercicio, se configurará un *workflow* que valide un archivo de configuración (``config.json``) y realice un despliegue condicional, ya sea al entorno de desarrollo o al de producción, según la rama desde la que se haya realizado el ``push``.

<br>

````yml
name: Branch Workflow

on:
  workflow_dispatch:

permissions:
  contents: write

jobs:
  branch-workflow:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        branch: [main, RaquelGarciaExercises] # Opciones de rama

    steps:
      - name: Checkout del código
        uses: actions/checkout@v4
        with:
          ref: ${{ matrix.branch }}

      - name: Crear archivo de configuración
        run: |
          echo '{
          "version": "1.0.0",
          "app_name": "fictional-app"
          }' > config.json

      - name: Comprobar existencia del archivo
        run: |
          if [ -f "config.json" ]; then
            echo "El archivo config.json existe."
          else
            echo "El archivo config.json NO existe."
            exit 1
          fi

      - name: Comprobar que el formato del archivo sea el correcto (JSON)
        run: |
          if jq empty config.json > /dev/null 2>&1; then
            echo "El formato del archivo es correcto."
          else
            echo "El formato del archivo no es válido."
            exit 1
          fi

      - name: Extraer valor del archivo
        id: extract_version
        run: |
          VERSION=$(jq -r '.version' config.json)
          echo "VERSION=$VERSION" >> $GITHUB_OUTPUT

      - name: Comprobar la información extraída
        run: echo "La versión del archivo es ${{ steps.extract_version.outputs.VERSION }}."     

      - name: Realizar push
        run: |
          git config user.name "Raquel"
          git config user.email "rgarcia@stemdo.io"
          git add config.json
          git commit -m "Commit generado por Github Actions"
          git push

      - name: Si push se hace desde main
        if: ${{ matrix.branch == 'main' }}
        run: |
          echo "Desplegando en el entorno producción..."
          echo "POST a https://fictional_deploy.com (simulado)"
          echo "Payload: {\"environment\": \"production\", \"version\": \"${{ steps.extract_version.outputs.VERSION }}\"}"        
          echo "El despliegue se ha realizado correctamente."
        

      - name: Si push se hace desde RaquelGarciaExercises
        if: ${{ matrix.branch == 'RaquelGarciaExercises' }}
        run: |
          echo "Desplegando en el entorno develop..."
          echo "POST a https://fictional_deploy.com (simulado)"
          echo "Payload: {\"environment\": \"develop\", \"version\": \"${{ steps.extract_version.outputs.VERSION }}\"}"        
          echo "El despliegue se ha realizado correctamente."
````

**Ascpectos importantes**:

- Se usa ``strategy.matrix`` para ejecutar el *workflow* sobre distintas ramas de manera automatizada, sin necesidad de ejecutarlo manualmente varias veces.

- La validación del formato del archivo ``config.json`` se realiza con la herramienta ``jq``.

- El valor del campo ``version`` se extrae del archivo y se guarda como ``output`` a nivel de *step**, lo que permite reutilizarlo fácilmente en pasos posteriores mediante el uso del contexto ``steps``.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Variables/ejercicio-4_1.4.png)

Se realiza ``push`` desde ``main``:

![resultado](/github-actions//datos/Variables/ejercicio-4_1.1.png)

Se realiza ``push`` desde ``RaquelGarciaExercises``:

![resultado](/github-actions//datos/Variables/ejercicio-4_1.2.png)

Se genera un error en el formato del archivo JSON:

![resultado](/github-actions//datos/Variables/ejercicio-4_1.3.png)



### Ejercicio 5

En este ejercicio, se configurará un *workflow* compuesto por varios *jobs* y *steps* que muestran distintas formas de manejar variables en GitHub Actions:

- **Variables entre pasos de un mismo *job*:**

  Se crea un *job*. Se define una variable local (``var1``) y una variable de entorno (``var2`` con ``$GITHUB_ENV``) y se imprime esta última en un paso posterior.

- **Compartir variables entre pasos usando *outputs*:**

  Se crea un *job*. Se declara un ``output`` (``var_step_output``) en un paso y se reutiliza en otro.

- **Compartir variables entre *jobs*:**
  
  Se intenta acceder a ``var2`` desde otro *job* y se define ``var3`` como ``output`` para compartirla entre *jobs*.

- **Imprimir variables entre *jobs*:**

  Se crea un *job* que dependa del anterior e imprime el valor de ``var3`` recibido del anterior.

- **Usar variables predefinidas de GitHub:**

  Se imprime el nombre del repositorio, la rama y el evento que activó el *workflow*.

<br>

````yml
name: Variables Workflow

on:
  workflow_dispatch:

jobs:
  job1:
    runs-on: ubuntu-latest
    outputs:
      var2: ${{ steps.var2_output.outputs.var2 }}

    steps:
      - name: Definir e imprimir variable local
        run: |
          var1="1"
          echo "Variable local: $var1"
      
      - name: Definir variable de entorno
        id: var2_output
        run: |
          echo "var2=2" >> $GITHUB_OUTPUT

      - name: Imprimir variable de entorno
        run: |
          echo "Variable de entorno: ${{ steps.var2_output.outputs.var2 }}"

  job2:
    runs-on: ubuntu-latest
    
    steps:
      - name: Definir output
        id: create_output
        run: |
          echo "var_step_output=valor" >> $GITHUB_OUTPUT

      - name: Imprimir output
        run: |
          echo "Salida output: ${{ steps.create_output.outputs.var_step_output }}"

  job3:
    runs-on: ubuntu-latest
    needs: [job1]
    outputs:
      var3: ${{ steps.var3_output.outputs.var3 }}
    
    steps:
      - name: Imprimir valor de var2
        run: |
          echo "var2 = ${{ needs.job1.outputs.var2 }}"
      
      - name: Definir output var3
        id: var3_output
        run: |
          echo "var3=3" >> $GITHUB_OUTPUT
  
  job4:
    runs-on: ubuntu-latest
    needs: [job3]

    steps:
      - name: Imprimir var3
        run: |
          echo "Valor de var3: ${{ needs.job3.outputs.var3 }}"
  
  job5:
    runs-on: ubuntu-latest

    steps:
      - name: Imprimir variables predefinidas
        run: |
          echo "Nombre del repositorio: ${GITHUB_REPOSITORY##*/}"
          echo "Nombre de la rama: ${GITHUB_REF_NAME}"
          echo "Nombre del evento que activó el workflow: ${GITHUB_EVENT_NAME}"
````

**Aspectos importantes**:

- En el ``job1``, se define una variable de entorno para compartir información entre *steps*, lo cual es válido dentro del mismo *job*. Sin embargo, cuando se intenta acceder a esa variable en un *job* posterior (``job2``), el valor no es accesible debido a que las variables de entorno definidas en un *job* no se transfieren automáticamente a otros *jobs*.

  Para solucionar esto, es necesario definir la variable como un ``output`` en el *step* correspondiente de ``job1``. De esta forma, el valor de la variable estará disponible para su uso en otros *jobs* que **dependan** de ``job1``.

- El acceso a las distintas variables se realiza mediante el uso de contextos y la definición de dependencias entre *jobs*.

- Mediante ``GITHUB_REPOSITORY##*/``, se consigue obtener únicamente el nombre del repositorio, eliminando todo aquello que se encuentre antes de la barra (``/``).

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Variables/ejercicio-5_1.7.png)

Job 1:

![resultado](/github-actions//datos/Variables/ejercicio-5_1.1.png)

Job 2 con variable de entorno:

![resultado](/github-actions//datos/Variables/ejercicio-5_1.2.png)

Job 2 con ``output``:

![resultado](/github-actions//datos/Variables/ejercicio-5_1.3.png)

Job 3:

![resultado](/github-actions//datos/Variables/ejercicio-5_1.4.png)

Job 4:

![resultado](/github-actions//datos/Variables/ejercicio-5_1.5.png)

Job 5:

![resultado](/github-actions//datos/Variables/ejercicio-5_1.6.png)