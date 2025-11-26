# Dockerfile

# Usa una imagen base oficial
FROM node:18

# Crea un directorio de trabajo dentro del contenedor
WORKDIR /app
    
# Copia el archivo package.json 
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código fuente al contenedor
COPY . .

# Puerto en el que la api escuchará las peticiones
EXPOSE 3000

# Define el comando por defecto para ejecutar el servidor
CMD ["node", "index.js"]