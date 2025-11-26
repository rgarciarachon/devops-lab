# Github Actions
## Jobs

En GitHub Actions, los *jobs* representan bloques de ejecución que reúnen un conjunto de *steps* destinados a realizar tareas específicas dentro del *workflow*.

A lo largo de los próximos ejercicios, se aprenderá a definir y organizar los *jobs* dentro de un *workflow*, así como a establecer relaciones entre ellos para controlar su orden de ejecución y dependencias.

### Ejercicio 1

En este ejercicio, se deberá configurar un *workflow* que ejecute varias tareas dentro de un mismo *job*. Más concretamente, este deberá:

- Mostrar la fecha y hora actual.
- Crear un archivo de texto.
- Listar los archivos en el directorio actual.
- Hacer un commit y push de cualquier fichero en el repositorio.

<br>

````yml
name: One Job Workflow

on:
  workflow_dispatch:

permissions:
  contents: write # Se activan los permisos de escritura para poder hacer las tareas

jobs:
  one-job-workflow:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del repositorio
        uses: actions/checkout@v4         

      - name: Mostrar fecha y hora actual
        run: date

      - name: Crear un archivo de texto
        run: echo "Archivo creado por el workflow." > jobs1.txt

      - name: Listar los archivos en el directorio actual
        run: ls -la     
      
      - name: Hacer un commit y push
        run: |
          git config user.name "Raquel"
          git config user.email "rgarcia@stemdo.io"
          git add jobs1.txt
          git commit -m "Commit generado por Github Actions"
          git push       
````

**Aspectos importantes**:

- Para trabajar con los archivos del repositorio, es necesario hacer un ``checkout``, lo que asegura que el contenido esté disponible en el entorno de ejecución del *workflow*.

- Para permitir cambios en el repositorio, como crear un commit o hacer un push, se deben configurar los permisos de escritura mediante la clave ``permissions``.

- Aunque GitHub Actions ejecuta el *workflow* en el contexto de una cuenta de usuario, es necesario configurar explícitamente la identidad de Git para asociar el commit con un autor válido.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

<br>

![resultado](/github-actions//datos/Jobs/ejercicio-1_1.5.png)

![resultado](/github-actions//datos/Jobs/ejercicio-1_1.1.png)

![resultado](/github-actions//datos/Jobs/ejercicio-1_1.2.png)

![resultado](/github-actions//datos/Jobs/ejercicio-1_1.3.png)

![resultado](/github-actions//datos/Jobs/ejercicio-1_1.4.png)



### Ejercicio 2

En este ejercicio, se profundizará en los *jobs* y sus dependencias. Se deberá crear un *workflow* que ejecute una serie de tareas distribuidas en dos *jobs* (*build* y *deploy*), donde la ejecución del segundo dependerá del éxito del primero.

Las tareas que deben realizar son:

- En el *job* **deploy** imprime un mensaje por la consola.
- El *job* **deploy** debe depender del éxito del *job* **build**.
- Si el *job* **build** falla, el *job* **deploy** no debe ejecutarse.

<br>

````yml
name: Two Jobs Workflow

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Prueba de ejecución
        run: echo "Ejecutando build..."


  deploy:
    runs-on: labs-runner
    needs: [build] # Deploy depende de Build

    steps:
      - name: Imprimir mensaje
        run: echo "Hola desde deploy."
````

**Aspectos importantes**:

- Para definir una dependencia entre *jobs*, se utiliza la clave ``needs`` seguida del nombre del *job* del que depende la ejecución.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* ha ejecutado los *jobs* en el orden establecido, cumpliendo con las dependencias definidas.

<br>

![resultado](/github-actions//datos/Jobs/ejercicio-2_1.4.png)

![resultado](/github-actions//datos/Jobs/ejercicio-2_1.1.png)

![resultado](/github-actions//datos/Jobs/ejercicio-2_1.2.png)

![resultado](/github-actions//datos/Jobs/ejercicio-2_1.3.png)

### Ejercicio 3

En este ejercicio, se deberá configurar un *workflow* que ejecute el mismo *job* en diferentes sistemas operativos.

Para ello, se utilizará la clave ``matrix``, la cual permite ejecutar un mismo *job* en múltiples entornos de manera simultánea.

````yml
name: OS Workflow

on:
  workflow_dispatch:

jobs:
  so-workflow:
    strategy: # Mediante strategy.matrix se crean combinaciones de valores
      matrix:
        os: [ubuntu-latest, windows-latest] # Opciones de sistema operativo
    
    runs-on: ${{ matrix.os }} # Variable que alterna entre los sistemas

    steps:
      - name: Imprimir mensaje
        run: echo "Hola desde ${{ matrix.os }}."
````

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado.

![resultado](/github-actions//datos/Jobs/ejercicio-3_1.4.png)

![resultado](/github-actions//datos/Jobs/ejercicio-3_1.1.png)

![resultado](/github-actions//datos/Jobs/ejercicio-3_1.2.png)

![resultado](/github-actions//datos/Jobs/ejercicio-3_1.3.png)

### Ejercicio 4

En este ejercicio, se deberá crear un *worflow* compuesto por dos *jobs* que ejecutan diversas tareas y comparten información entre sí.

Más concretamente, se deberá:

- Definir un *job* que cree un archivo ``.txt`` llamado **test**.

- Definir otro *job* que mueva el archivo creado anteriormente a otro directorio.

<br>

````yml
name: Move Workflow

on:
  workflow_dispatch:

jobs:
  create-archive:
    runs-on: ubuntu-latest

    steps:        
      - name: Crear archivo
        run: echo "Hola desde el primer job." > test.txt

      # Se almacena el archivo como artefacto para poder usarlo entre jobs
      - name: Almacenar archivo como artefacto
        uses: actions/upload-artifact@v4
        with:
          name: test-archive
          path: test.txt
  
  move-archive:
    runs-on: ubuntu-latest
    needs: [create-archive]

    steps:
      - name: Descargar el artefacto
        uses: actions/download-artifact@v4
        with:
          name: test-archive

      - name: Crear directorio de destino
        run: mkdir jobs4/
      
      - name: Mover archivo a otro directorio
        run: mv test.txt jobs4/

      - name: Verificar el estado y mostrar su contenido
        run: | 
          ls -l jobs4/
          cat jobs4/test.txt
````

**Aspectos importantes**:

- Se ha establecido una dependencia entre *jobs* mediante el intercambio de un archivo, lo que implica que uno de los *jobs* debe completarse correctamente antes de que el otro pueda ejecutarse. Esto se consigue mediante la clave ``needs``.

- La transmisión de información entre *jobs* en un *workflow* no es directa, ya que cada *job* se ejecuta en un entorno separado.

- Dependiendo del tipo de información que se necesite transmitir, existen varias opciones: **artefactos**, **outputs** o **variables de entorno**.

En este caso particular, los *jobs* deben compartir archivos, por lo que la opción más adecuada y eficiente es el uso de artefactos.

Los artefactos permiten almacenar archivos generados por un *job* y ponerlos a disposición de otros *jobs* dentro del mismo *workflow*.

Como se puede observar, el archivo se ha subido correctamente y el *workflow* se ha ejecutado según lo esperado, respetando la dependencia y recuperando el artefacto generado por el *job* anterior.

![resultado](/github-actions//datos/Jobs/ejercicio-4_1.4.png)

![resultado](/github-actions//datos/Jobs/ejercicio-4_1.3.png)

![resultado](/github-actions//datos/Jobs/ejercicio-4_1.1.png)

![resultado](/github-actions//datos/Jobs/ejercicio-4_1.2.png)